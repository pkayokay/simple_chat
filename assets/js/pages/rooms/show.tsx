import { Link, useForm, usePage } from "@inertiajs/react";
import { Presence, Socket } from "phoenix";
import { useEffect, useRef, useState } from "react";

import { Heading } from "../ui/heading";
import { RoomType } from "./interface";
type RoomMessageType = {
  content: string;
  id: string;
  insertedAt: string;
  userId: string;
  userNickname: string;
};

type UserType = {
  id: string;
  nickname: string;
};

const RoomsShow = ({ room, roomMessages }: { room: RoomType; roomMessages: RoomMessageType[] }) => {
  const [roomMessagesState, setRoomMessagesState] = useState<RoomMessageType[]>(roomMessages);
  const page = usePage<{ currentUrl: string; currentUser: { id: string; nickname: string } }>();
  const { currentUrl, currentUser } = page.props;
  const ref = useRef<HTMLDivElement>(null);
  const [values, setValues] = useState({
    content: "",
    room_id: room.id,
    user_id: currentUser.id,
    user_nickname: currentUser.nickname,
  });

  console.log("Room messages:", roomMessagesState);

  useEffect(() => {
    if (ref.current) {
      ref.current.scrollTop = ref.current.scrollHeight;
    }
  }, []);
  const [onlineUsers, setOnlineUsers] = useState<UserType[]>([]);

  useEffect(() => {
    const socket = new Socket("/socket");
    socket.connect();

    const channel = socket.channel(`room:${room.slug}`, { id: currentUser?.id, nickname: currentUser?.nickname });
    const presence = new Presence(channel);

    // Handle presence sync
    presence.onSync(() => {
      const list = presence.list();

      // Flatten all metas
      const allMetas: UserType[] = [];
      Object.values(list).forEach((entry: { metas: UserType[] }) => {
        entry.metas.forEach((meta) => {
          allMetas.push({ id: meta.id, nickname: meta.nickname });
        });
      });

      // Sort alphabetically by nickname and pull out unique users
      const uniqueUsers = Array.from(new Map(allMetas.map((user) => [user.id, user])).values());
      uniqueUsers.sort((a, b) => {
        if (b.id === currentUser.id) return 1; // current user comes first
        if (a.id === currentUser.id) return -1;
        return a.nickname.localeCompare(b.nickname); // otherwise alphabetical
      });
      setOnlineUsers(uniqueUsers);
    });

    channel
      .join()
      .receive("ok", () => console.log("✅ Joined room:", room.slug))
      .receive("error", (err) => console.error("❌ Failed to join room", err));

    return () => {
      channel.leave();
      socket.disconnect();
    };
  }, [room.slug, currentUser]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

    fetch("/room_messages", {
      body: JSON.stringify({ room_message: values }),
      headers: {
        "Content-Type": "application/json",
        "x-csrf-token": csrfToken,
      },
      method: "POST",
    }).then((response) => {
      setRoomMessagesState([
        ...roomMessagesState,
        {
          content: values.content,
          id: crypto.randomUUID(), // temporary client ID
          insertedAt: new Date().toISOString(),
          userId: currentUser.id,
          userNickname: currentUser.nickname,
        },
      ]);
      setValues({ ...values, content: "" });
      setTimeout(() => {
        if (ref.current) {
          ref.current.scrollTop = ref.current.scrollHeight;
        }
      }, 300);
      // if (response.ok) {
      //   console.error("Failed to send message");
      // } else {

      // }
    });
  };

  return (
    <>
      <div className="mb-6 flex items-center justify-between">
        <Link className="text-blue-500 hover:underline" href="/rooms">
          &larr; Rooms
        </Link>
        <span>
          Signed in as <strong>{currentUser.nickname}</strong>
        </span>
      </div>

      <Heading text={room.name} />
      <p className="mt-2">{currentUrl}</p>

      <div className="gri-cols-1 mt-6 grid gap-5 sm:grid-cols-[220px_1fr]">
        <div className="rounded-md border border-neutral-300 p-4">
          👥 {onlineUsers.length} {onlineUsers.length === 1 ? "person" : "people"} online
          <div className="mt-1">
            {onlineUsers.map((user) => (
              <p className="text-lg font-semibold" key={`${user.id}-${user.nickname}`}>
                <span className="mr-2 inline-block h-2 w-2 animate-pulse rounded-full bg-green-500"></span>
                <span>{user.nickname}</span>
                {user.id === currentUser.id && " (You)"}
              </p>
            ))}
          </div>
        </div>
        <div className="h-[400px] space-y-4 overflow-y-auto rounded-md border border-neutral-300 p-4" ref={ref}>
          {roomMessagesState.map((message: RoomMessageType) => {
            const isCurrentUser = message.userId === currentUser.id || message.userId === 0; // replace currentUser.id with your current user state

            return (
              <div
                className={`flex ${isCurrentUser ? "justify-end" : "justify-start"}`}
                key={`${message.userNickname}-${message.userId}`}
                key={message.id}
              >
                <div
                  className={`w-full max-w-[70%] break-words rounded-md p-2 ${isCurrentUser ? "bg-blue-500 text-white" : "bg-gray-200 text-gray-900"}`}
                >
                  <p>{message.userId}</p>
                  <p>{message.content}</p>
                  <p className="mt-1 text-xs opacity-70">{message.userNickname}</p>
                  <p className="mt-1 text-right text-xs opacity-70">{message.insertedAt}</p>
                </div>
              </div>
            );
          })}
        </div>
      </div>
      <div className="sticky bottom-0 mt-8 w-full border-t border-neutral-300 bg-white py-4">
        <form onSubmit={handleSubmit}>
          <input
            className="input--default w-full"
            name="content"
            onChange={(e) => setValues({ ...values, content: e.target.value })}
            placeholder="Type your message..."
            type="text"
            value={values.content}
          />
          <button className="button--primary mt-2 w-full" disabled={!values.content.trim()} type="submit">
            Send
          </button>
        </form>
      </div>
    </>
  );
};

export default RoomsShow;
