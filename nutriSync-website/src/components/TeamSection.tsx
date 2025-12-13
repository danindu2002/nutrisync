import RaveeshaImg from "../assets/team/raveesha.png";
import NirmalImg from "../assets/team/nirmal.png";
import DaninduImg from "../assets/team/danindu.png";
import CharinImg from "../assets/team/charin.png";
import SeniruImg from "../assets/team/seniru.jpg";
import DilshanImg from "../assets/team/dilshan.jpg";

const members = [
  {
    name: "Danindu Srinath",
    avatar: DaninduImg,
  },
  {
    name: "Charin Fernando",
    avatar: CharinImg,
  },
  {
    name: "Dilshan Peiris",
    avatar: DilshanImg,
  },
  {
    name: "Nirmal Dabarera",
    avatar: NirmalImg,
  },
  {
    name: "Raveesha Cooray",
    avatar: RaveeshaImg,
  },
  {
    name: "Seniru Ranjula",
    avatar: SeniruImg,
  },
];

export default function TeamSection() {
  return (
    <div id="team" className="mx-auto max-w-6xl px-4 lg:px-4 mb-15">
      <h2 className="mb-8 text-4xl font-bold md:mb-8 lg:text-5xl">Our team</h2>

      <div>
        <h3 className="mb-6 text-lg font-low">
          Meet the brilliant minds driving our mission forward. A team powered
          by passion, innovation, and relentless dedication.
        </h3>

        <div className="overflow-x-auto">
          <div className="flex justify-between gap-6 py-6 min-w-max">
            {members.map((member, index) => (
              <div key={index} className="flex flex-col items-center">
                <div className="size-40 rounded-full border border-[#aaa] p-0.5 shadow shadow-zinc-950/5">
                  <img
                    className="aspect-square rounded-full object-cover"
                    src={
                      typeof member.avatar === "string"
                        ? member.avatar
                        : member.avatar.src
                    }
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
