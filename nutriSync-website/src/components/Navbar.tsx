"use client";

import { Github } from "lucide-react";
import { useEffect, useState } from "react";
import Button from "./Button";

const Navbar = () => {
  const links = [
    { name: "Home", href: "#home" },
    { name: "Features", href: "#features" },
    { name: "How it Works", href: "#how-it-works" },
    { name: "Team", href: "#team" },
  ];
  const [isScrolled, setIsScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 50);
    };

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  const handleSmoothScroll = (
    e: React.MouseEvent<HTMLAnchorElement>,
    href: string
  ) => {
    e.preventDefault();
    const targetId = href.replace("#", "");
    const element = document.getElementById(targetId);

    if (element) {
      const navbarHeight = 80; // Approximate navbar height
      const elementPosition = element.getBoundingClientRect().top;
      const offsetPosition =
        elementPosition + window.pageYOffset - navbarHeight;

      window.scrollTo({
        top: offsetPosition,
        behavior: "smooth",
      });
    }
  };

  return (
    <nav
      className={`fixed top-0 left-0 right-0 z-50 w-full transition-all duration-300 ${
        isScrolled
          ? "backdrop-blur-md bg-black/50 border-b border-white/10 shadow-lg"
          : "bg-transparent border-b border-transparent"
      }`}
    >
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="flex h-16 sm:h-18 md:h-20 items-center justify-between">
          {/* Brand Name Only */}
          <div className="flex items-center">
            <a
              href="#home"
              onClick={(e) => handleSmoothScroll(e, "#home")}
              className="text-lg sm:text-xl md:text-2xl font-bold text-white tracking-tight cursor-pointer hover:opacity-80 transition-opacity"
            >
              NutriSync
            </a>
          </div>

          {/* Glassmorphic Navigation Pills */}
          <div
            className={`hidden md:flex items-center space-x-1 transition-all ${
              isScrolled
                ? "space-x-2"
                : "rounded-full bg-white/5 backdrop-blur-xl border border-white/10 p-1.5 hover:bg-white/[0.07]"
            }`}
          >
            {links?.map((link) => (
              <a
                key={link.name}
                href={link.href}
                onClick={(e) => handleSmoothScroll(e, link.href)}
                className={`px-4 py-2.5 text-sm font-medium text-white/90 transition-all hover:text-white cursor-pointer ${
                  isScrolled
                    ? "hover:bg-white/5 rounded-md"
                    : "rounded-full hover:bg-white/10"
                }`}
              >
                {link.name}
              </a>
            ))}
          </div>

          {/* CTA Button */}
          <div className="flex items-center space-x-3 sm:space-x-4">
            <Button
              variant="ghost"
              size="sm"
              className="hidden sm:flex text-sm"
            >
              <Github className="mr-2 h-4 w-4" />
              GitHub
            </Button>
            {/* <Button size="sm">
                Get Started
                <ArrowRight className="ml-2 h-4 w-4" />
              </Button> */}
          </div>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
