import FeaturesSection from "@/components/FeaturesSection";
import FooterSection from "@/components/Footer";
import { HowItWorks } from "@/components/HowItWorks";
import Navbar from "@/components/Navbar";
import TeamSection from "@/components/TeamSection";
import HeroSection from "@/components/HeroSection";
import { HeroGeometric } from "@/components/HeroGeometric";

const HomePage: React.FC = () => {
  return (
    <main>
      <Navbar />
      {/* <HeroGeometric /> */}
      <HeroSection />
      <FeaturesSection />
      <HowItWorks />
      <TeamSection />
      <FooterSection />
    </main>
  );
};

export default HomePage;
