"use client";
import mobileScreen1Img from "@/assets/screen-01.png";
import Image from "next/image";

export default function DetailsSection() {
  return (
    <section className="w-full bg-[#FFF8EB] py-24 px-8">
      <div className="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-2 gap-20 items-center">
        {/* ---------------- LEFT SIDE ---------------- */}
        <div>
          <h1 className="text-4xl md:text-6xl font-bold leading-tight">
            Lead generation <span className="text-blue-600">mobile app</span>
            <br />
            landing page
          </h1>
          <p className="mt-6 text-gray-600 max-w-lg text-lg">
            Lorem ipsum is simply dummy text of the printing industry. Lorem
            ipsum has been the industry's standard.
          </p>
          <p className="text-gray-500 max-w-xs">
            The best application to manage your customers worldwide.
          </p>
        </div>

        {/* ---------------- RIGHT SIDE ---------------- */}
        <div className="relative flex justify-center overflow-hidden">
          <Image
            src={mobileScreen1Img}
            alt="iPhone Frame"
            height={400}
            className="z-10 pointer-events-none"
          />
        </div>
      </div>
    </section>
  );
}
