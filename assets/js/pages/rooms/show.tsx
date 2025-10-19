import { Link, usePage } from "@inertiajs/react";

import { Heading } from "../ui/heading";
import { RoomType } from "./interface";

const RoomsShow = ({ room }: { room: RoomType }) => {
  const page = usePage<{ currentUrl: string }>();
  const { currentUrl } = page.props;
  return (
    <>
      <div className="mb-6">
        <Link className="text-blue-500 hover:text-blue-600 hover:underline focus:text-blue-600" href="/rooms">
          &larr; Rooms
        </Link>
      </div>
      <Heading text={room.name} />

      <p className="mt-2">{currentUrl}</p>
    </>
  );
};

export default RoomsShow;
