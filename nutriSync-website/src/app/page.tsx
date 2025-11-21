import { HeroGeometric } from "@/components/Hero";
import React from "react";
import { Features } from "@/components/Features";
import { HowItWorks } from "@/components/HowItWorks";
import { Pricing } from "@/components/Pricing";
import FeaturesSection from "@/components/FeaturesSection";
import DetailsSection from "@/components/DetailsSection";
import Navbar from "@/components/Navbar";
import TeamSection from "@/components/Team";
import { Footer } from "@/components/ui/footer";
import FooterSection from "@/components/Footer";

const HomePage: React.FC = () => {
  return (
    <main>
      {/* <main className="flex flex-col items-center justify-center min-h-screen"> */}
      {/* <Features /> */}
      {/* <DetailsSection /> */}
      <Navbar />
      <HeroGeometric />
      <FeaturesSection />
      <HowItWorks />
      <TeamSection />
      <FooterSection />
      {/* <FooterSection /> */}
    </main>
  );
};

export default HomePage;
