const members = [
  {
    name: "Danindu Srinath",
    avatar: "https://avatars.githubusercontent.com/u/47919550?v=4",
  },
  {
    name: "Charin Fernando",
    avatar: "https://avatars.githubusercontent.com/u/68236786?v=4",
  },
  {
    name: "Dilshan Peiris",
    avatar: "https://avatars.githubusercontent.com/u/99137927?v=4",
  },
  {
    name: "Nirmal Dabarera",
    avatar: "https://avatars.githubusercontent.com/u/47919550?v=4",
  },
  {
    name: "Raveesha Cooray",
    avatar: "https://avatars.githubusercontent.com/u/68236786?v=4",
  },
  {
    name: "Seniru Ranjula",
    avatar: "https://avatars.githubusercontent.com/u/31113941?v=4",
  },
];

export default function TeamSection() {
  return (
    <div id="team" className="mx-auto max-w-6xl px-4 lg:px-4 mb-15">
      <h2 className="mb-8 text-4xl font-bold md:mb-16 lg:text-5xl">Our team</h2>

      <div>
        <h3 className="mb-6 text-lg font-low">
          Meet the brilliant minds driving our mission forward. A team powered
          by passion, innovation, and relentless dedication.
        </h3>

        <div className="overflow-x-auto">
          <div className="flex justify-between gap-6 py-6 min-w-max">
            {members.map((member, index) => (
              <div key={index} className="flex flex-col items-center">
                <div className="size-40 rounded-full border p-0.5 shadow shadow-zinc-950/5">
                  <img
                    className="aspect-square rounded-full object-cover"
                    src={member.avatar}
                    alt={member.name}
                    height="200"
                    width="200"
                    loading="lazy"
                  />
                </div>
                <span className="mt-2 text-sm text-center">{member.name}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
