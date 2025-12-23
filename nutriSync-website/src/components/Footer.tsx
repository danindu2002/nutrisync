import { Hexagon, Github } from "lucide-react";
import { Footer } from "@/components/ui/footer";

function FooterSection() {
  return (
    <div className="w-full">
      <Footer
        // logo={<Hexagon className="h-10 w-10" />}
        brandName="NutriSync"
        socialLinks={[
          {
            icon: <Github className="h-5 w-5" />,
            href: "https://github.com/danindu2002/nutrisync",
            label: "GitHub",
          },
        ]}
        mainLinks={[
          { href: "#home", label: "Home" },
          { href: "#features", label: "Features" },
          { href: "#how-it-works", label: "How it Works" },
          { href: "#team", label: "Team" },
        ]}
        legalLinks={[
          { href: "#", label: "Privacy" },
          { href: "#", label: "Terms" },
        ]}
        copyright={{
          text: "© 2025 NutriSync",
          license: "All rights reserved",
        }}
      />
    </div>
  );
}

export default FooterSection;
