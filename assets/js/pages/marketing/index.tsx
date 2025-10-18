import { Form, Link, usePage } from "@inertiajs/react";
import { useState } from "react";

import { Heading } from "../ui/heading";

const MarketingIndex = () => {
  const page = usePage<{ cookieUserNickname: null | string }>();
  const { cookieUserNickname } = page.props;
  const [disabled, setDisabled] = useState(true);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setDisabled(!e.target.value?.trim());
  };

  if (cookieUserNickname) {
    return (
      <div>
        <Heading text={`Welcome back, ${cookieUserNickname}!`} />
        <Form action="/log_out" method="delete">
          <button className="underline" type="submit">
            Log Out
          </button>
        </Form>
        <p>Click here to see all rooms</p>
        <Link className="text-blue-500 underline" href="/rooms">
          Go to Rooms
        </Link>
      </div>
    );
  }
  return (
    <div>
      <Heading text="Simple Chat" />
      <Form action="/sign_in" method="post">
        <label htmlFor="nickname">Nickname</label>
        <br />
        <input autoFocus id="nickname" name="nickname" onChange={handleChange} placeholder="Enter your nickname" type="text" />
        <br />
        <button className="bg-black text-white disabled:opacity-50" disabled={disabled} type="submit">
          Start Chatting
        </button>
      </Form>
    </div>
  );
};

export default MarketingIndex;
