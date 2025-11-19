import { HeroGeometric } from "@/components/Hero";
import React from "react";
import FooterSection from "@/components/SiteFooter";
import { Features } from "@/components/Features";
import { HowItWorks } from "@/components/HowItWorks";
import { Pricing } from "@/components/Pricing";
import { Footer } from "@/components/Footer";
import FeaturesSection from "@/components/FeaturesSection";
import { ContainerScroll } from "@/components/ui/container-scroll-animation";
import TeamSection from "@/components/team";

const HomePage: React.FC = () => {
  return (
    <main className="flex flex-col items-center justify-center min-h-screen">
      <HeroGeometric />
      <ContainerScroll
        titleComponent={
          <>
            <h1 className="text-4xl font-semibold text-black dark:text-white">
              Unleash the power of <br />
              <span className="text-4xl md:text-[6rem] font-bold mt-1 leading-none">
                Scroll Animations
              </span>
            </h1>
          </>
        }
      >
        <></>
      </ContainerScroll>
      {/* <Features /> */}
      <FeaturesSection />
      <HowItWorks />
      <TeamSection />
      {/* <Pricing /> */}
      <Footer />
      {/* <FooterSection /> */}
    </main>
  );
};

export default HomePage;
