import { Link, usePage } from "@inertiajs/react";
import { Presence, Socket } from "phoenix";
import { useEffect, useState } from "react";

import { Heading } from "../ui/heading";
import { RoomType } from "./interface";
type UserType = {
  id: string;
  nickname: string;
};

const RoomsShow = ({ room }: { room: RoomType }) => {
  const page = usePage<{ currentUrl: string; currentUser: { id: string; nickname: string } | null }>();
  const { currentUrl, currentUser } = page.props;

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
      Object.values(list).forEach((entry: any) => {
        entry.metas.forEach((meta: any) => {
          allMetas.push({ id: meta.id, nickname: meta.nickname });
        });
      });

      // Remove duplicates based on id
      const uniqueUsers = Array.from(new Map(allMetas.map((user) => [user.id, user])).values());

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

  console.log("Online users:", onlineUsers);
  return (
    <>
      <div className="mb-6">
        <Link className="text-blue-500 hover:underline" href="/rooms">
          &larr; Rooms
        </Link>
      </div>

      <Heading text={room.name} />
      <p className="mt-2">{currentUrl}</p>

      <div className="mt-4">
        👥 {onlineUsers.length} {onlineUsers.length === 1 ? "person" : "people"} online
        <div className="mt-1">
          {onlineUsers.map((user) => (
            <p className="text-lg font-semibold" key={user.id}>
              {user.nickname}
            </p>
          ))}
        </div>
      </div>
    </>
  );
};

export default RoomsShow;
