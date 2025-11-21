// import { Facebook, Twitter, Instagram, Youtube } from "lucide-react";

// export const Footer = () => {
//   return (
//     <footer className="bg-card border-t border-border py-12">
//       <div className="container mx-auto px-4">
//         <div className="grid md:grid-cols-4 gap-8 mb-8">
//           <div>
//             <h3 className="font-bold text-lg mb-4">NutriSync</h3>
//             <p className="text-muted-foreground text-sm">
//               Making healthy eating simple, delicious, and accessible for
//               everyone.
//             </p>
//           </div>

//           <div>
//             <h4 className="font-semibold mb-4">Product</h4>
//             <ul className="space-y-2 text-sm">
//               <li>
//                 <a
//                   href="#home"
//                   className="text-muted-foreground hover:text-primary transition-colors"
//                 >
//                   Home
//                 </a>
//               </li>
//               <li>
//                 <a
//                   href="#features"
//                   className="text-muted-foreground hover:text-primary transition-colors"
//                 >
//                   Features
//                 </a>
//               </li>
//               <li>
//                 <a
//                   href="#how-it-works"
//                   className="text-muted-foreground hover:text-primary transition-colors"
//                 >
//                   How it Works
//                 </a>
//               </li>
//               <li>
//                 <a
//                   href="#team"
//                   className="text-muted-foreground hover:text-primary transition-colors"
//                 >
//                   Team
//                 </a>
//               </li>
//             </ul>
//           </div>

//           <div>
//             <h4 className="font-semibold mb-4">Follow Us</h4>
//             <div className="flex gap-4">
//               <a
//                 href="#"
//                 className="text-muted-foreground hover:text-primary transition-colors"
//               >
//                 <Facebook className="w-5 h-5" />
//               </a>
//               <a
//                 href="#"
//                 className="text-muted-foreground hover:text-primary transition-colors"
//               >
//                 <Twitter className="w-5 h-5" />
//               </a>
//               <a
//                 href="#"
//                 className="text-muted-foreground hover:text-primary transition-colors"
//               >
//                 <Instagram className="w-5 h-5" />
//               </a>
//               <a
//                 href="#"
//                 className="text-muted-foreground hover:text-primary transition-colors"
//               >
//                 <Youtube className="w-5 h-5" />
//               </a>
//             </div>
//           </div>
//         </div>

//         <div className="border-t border-border pt-8 text-center text-sm text-muted-foreground">
//           <p>
//             &copy; 2025 NutriSync. All rights reserved. | Privacy Policy | Terms
//             of Service
//           </p>
//         </div>
//       </div>
//     </footer>
//   );
// };

import { Hexagon, Github, Twitter } from "lucide-react";
import { Footer } from "@/components/ui/footer";

function FooterSection() {
  return (
    <div className="w-full">
      <Footer
        logo={<Hexagon className="h-10 w-10" />}
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
