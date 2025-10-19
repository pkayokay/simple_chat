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
  const page = usePage<{ currentUrl: string; currentUser: { id: string; nickname: string } }>();
  const { currentUrl, currentUser } = page.props;
  const ref = useRef<HTMLDivElement>(null);

  console.log("Room messages:", roomMessages);
  const { data, post, setData, transform } = useForm({
    content: "",
    room_id: room.id,
    user_id: currentUser.id,
    user_nickname: currentUser.nickname,
  });

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
      uniqueUsers.sort((a, b) => a.nickname.localeCompare(b.nickname));

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
    transform((data) => ({
      room_message: {
        ...data,
      },
    }));
    post("/room_messages", {
      onSuccess: () => {
        setData("content", "");

        setTimeout(() => {
          if (ref.current) {
            ref.current.scrollTop = ref.current.scrollHeight;
          }
        }, 0); // wait until DOM updates
      },
      preserveScroll: true,
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
              <p className="text-lg font-semibold" key={user.id}>
                <span className="mr-2 inline-block h-2 w-2 animate-pulse rounded-full bg-green-500"></span>
                <span>{user.nickname}</span>
              </p>
            ))}
          </div>
        </div>
        <div ref={ref} className="h-[400px] space-y-4 overflow-y-auto rounded-md border border-neutral-300 p-4">
          {roomMessages.map((message: RoomMessageType) => {
            const isCurrentUser = message.userId === currentUser.id; // replace currentUser.id with your current user state

            return (
              <div className={`flex ${isCurrentUser ? "justify-end" : "justify-start"}`} key={message.id}>
                <div
                  className={`w-full max-w-[70%] break-words rounded-md p-2 ${isCurrentUser ? "bg-blue-500 text-white" : "bg-gray-200 text-gray-900"}`}
                >
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
            onChange={(e) => setData("content", e.target.value)}
            placeholder="Type your message..."
            type="text"
            value={data.content}
          />
          <button className="button--primary mt-2 w-full" disabled={!data.content.trim()} type="submit">
            Send
          </button>
        </form>
      </div>
    </>
  );
};

export default RoomsShow;
