import { Form, Link, usePage } from "@inertiajs/react";
import { useState } from "react";

import { Heading } from "../ui/heading";

const MarketingIndex = () => {
  const page = usePage<{ currentUser: { id: string; nickname: string } | null }>();
  const { currentUser } = page.props;
  const [disabled, setDisabled] = useState(true);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setDisabled(!e.target.value?.trim());
  };
  const returnToParams = new URLSearchParams(window.location.search).get("return_to") || "";

  return (
    <div className="mt-16 text-center">
      <Heading text="Welcome to Simple Chat" />
      {currentUser ? (
        <p className="mt-3">
          You are signed in as {currentUser.nickname}. Click{" "}
          <Link className="text-blue-600 underline hover:text-blue-700 focus:text-blue-700" href="/rooms">
            here
          </Link>{" "}
          to see all rooms
        </p>
      ) : (
        <Form action="/sign_in" method="post">
          <p className="mb-3 mt-6 text-lg">Enter a nickname to start chatting</p>
          <label className="label--default" htmlFor="nickname">
            Nickname
          </label>
          <input name="return_to" type="hidden" value={returnToParams} />
          <input
            autoFocus
            className="input--default"
            id="nickname"
            name="nickname"
            onChange={handleChange}
            placeholder="Enter your nickname"
            type="text"
          />
          <button className="button--primary w-full" disabled={disabled} type="submit">
            Start Chatting
          </button>
        </Form>
      )}
    </div>
  );
};

export default MarketingIndex;
