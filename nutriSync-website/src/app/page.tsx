import FeaturesSection from "@/components/FeaturesSection";
import FooterSection from "@/components/Footer";
import { HeroGeometric } from "@/components/Hero";
import { HowItWorks } from "@/components/HowItWorks";
import Navbar from "@/components/Navbar";
import TeamSection from "@/components/TeamSection";
import React from "react";

const HomePage: React.FC = () => {
  return (
    <main>
      {/* <main className="flex flex-col items-center justify-center min-h-screen"> */}
      <Navbar />
      <HeroGeometric />
      <FeaturesSection />
      <HowItWorks />
      <TeamSection />
      <FooterSection />
    </main>
  );
};

export default HomePage;
