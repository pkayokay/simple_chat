import { Form, Link } from "@inertiajs/react";
import { useState } from "react";

import { Heading } from "../ui/heading";

const RoomsNew = () => {
  const [disabled, setDisabled] = useState(true);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setDisabled(!e.target.value?.trim());
  };

  return (
    <>
      <div className="mb-6">
        <Link className="text-blue-500 hover:text-blue-600 hover:underline focus:text-blue-600" href="/rooms">
          &larr; Rooms
        </Link>
      </div>
      <Heading text="Create New Room" />
      <Form action="/rooms" className="mt-6 space-y-4" method="post">
        {({ errors }) => (
          <>
            <label className="label--default" htmlFor="room[name]">
              Room Name
            </label>
            <input className="input--default" id="room[name]" name="room[name]" onChange={handleChange} required type="text" />
            {errors.name && <div style={{ color: "red" }}>{errors.name}</div>}
            <button className="button--primary" disabled={disabled} type="submit">
              Create Room
            </button>
          </>
        )}
      </Form>
    </>
  );
};

export default RoomsNew;
