import FeaturesSection from "@/components/FeaturesSection";
import FooterSection from "@/components/Footer";
import { HowItWorks } from "@/components/HowItWorks";
import Navbar from "@/components/Navbar";
import TeamSection from "@/components/TeamSection";
import NewHero from "@/components/NewHero";

const HomePage: React.FC = () => {
  return (
    <main>
      <Navbar />
      <NewHero/>
      <FeaturesSection />
      <HowItWorks />
      <TeamSection />
      <FooterSection />
    </main>
  );
};

export default HomePage;
