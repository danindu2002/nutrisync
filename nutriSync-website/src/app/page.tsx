import { HeroGeometric } from "@/components/Hero";
import React from "react";
import FooterSection from "@/components/SiteFooter";
import { Features } from "@/components/Features";
import { HowItWorks } from "@/components/HowItWorks";
import { Pricing } from "@/components/Pricing";
import { Footer } from "@/components/Footer";
import FeaturesSection from "@/components/FeaturesSection";
import DetailsSection from "@/components/DetailsSection";
import Navbar from "@/components/Navbar";
import TeamSection from "@/components/Team";

const HomePage: React.FC = () => {
  return (
    <main className="flex flex-col items-center justify-center">
      {/* <main className="flex flex-col items-center justify-center min-h-screen"> */}
      {/* <Features /> */}
      {/* <DetailsSection /> */}
      <Navbar />
      <HeroGeometric />
      <FeaturesSection />
      <HowItWorks />
      <TeamSection />
      <Footer />
      {/* <FooterSection /> */}
    </main>
  );
};

export default HomePage;
