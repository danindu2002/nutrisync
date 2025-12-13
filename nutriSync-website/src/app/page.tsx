import FeaturesSection from "@/components/FeaturesSection";
import FooterSection from "@/components/Footer";
import { HowItWorks } from "@/components/HowItWorks";
import Navbar from "@/components/Navbar";
import NutritionHero from "@/components/NutritionHero";
import TeamSection from "@/components/TeamSection";
import React from "react";

const HomePage: React.FC = () => {
  return (
    <main>
      {/* <main className="flex flex-col items-center justify-center min-h-screen"> */}
      <Navbar />
      {/* <HeroGeometric /> */}
      <NutritionHero />
      <FeaturesSection />
      <HowItWorks />
      <TeamSection />
      <FooterSection />
    </main>
  );
};

export default HomePage;
