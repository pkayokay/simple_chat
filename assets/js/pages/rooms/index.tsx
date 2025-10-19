import { Link } from "@inertiajs/react";

import { Heading } from "../ui/heading";
import { RoomType } from "./interface";

const RoomsIndex = ({ rooms }: { rooms: RoomType[] }) => {
  return (
    <>
      <div className="mb-6">
        <Link className="text-blue-500 hover:text-blue-600 hover:underline focus:text-blue-600" href="/">
          &larr; Go To Home Page
        </Link>
      </div>
      <div className="mb-6 flex items-center justify-between">
        <Heading text="Rooms" />
        <Link className="button--primary" href="/rooms/new">
          Create New Room
        </Link>
      </div>
      {rooms.length === 0 ? (
        <p className="mt-8 text-center">No rooms available.</p>
      ) : (
        <ul className="space-y-4">
          {rooms.map((room) => (
            <li key={room.id}>
              <Link
                className="flex items-center justify-between rounded-md bg-neutral-100/80 p-5 font-semibold text-blue-500 hover:bg-blue-100"
                href={`/rooms/${room.slug}`}
              >
                <span>{room.name}</span>
                <span>{room.insertedAt}</span>
              </Link>
            </li>
          ))}
        </ul>
      )}
    </>
  );
};

export default RoomsIndex;
