import { Head, Link, usePage } from "@inertiajs/react";

export default function MarketingLayout({ children }: { children: React.ReactNode }) {
  const page = usePage<{ currentUser: { id: string; nickname: string } | null; flash: { error?: string; info?: string }; pageTitle: string }>();
  const { currentUser, flash, pageTitle } = page.props;
  const flashMessage = flash.info || flash.error;
  if (flashMessage) {
    alert(flashMessage);
  }

  return (
    <div className="p-5">
      <Head>
        <title>{pageTitle}</title>
      </Head>
      <div className="mb-5 flex gap-3">
        <Link className="text-blue-500 hover:text-blue-600 hover:underline focus:text-blue-600" href="/">
          Simple Chat
        </Link>
        <div className="ml-auto flex gap-3">
          <Link className="text-blue-500 hover:text-blue-600 hover:underline focus:text-blue-600" href="/about">
            About
          </Link>
          <Link className="text-blue-500 hover:text-blue-600 hover:underline focus:text-blue-600" href="/rooms">
            Rooms
          </Link>
          {currentUser && (
            <Link className="text-blue-500 hover:text-blue-600 hover:underline focus:text-blue-600" href="/log_out" method="delete">
              Log out
            </Link>
          )}
        </div>
      </div>
      <main>{children}</main>
    </div>
  );
}
