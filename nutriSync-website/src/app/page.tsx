import { HeroGeometric } from '@/components/Hero';
import React from 'react';
import FooterSection from '@/components/SiteFooter';
import { Features } from '@/components/Features';
import { HowItWorks } from '@/components/HowItWorks';
import { Pricing } from '@/components/Pricing';
import { Footer } from '@/components/Footer';

const HomePage: React.FC = () => {
    return (
        <main className="flex flex-col items-center justify-center min-h-screen">
            <HeroGeometric />
            <Features/>
            <HowItWorks/>
            <Pricing/>
            <Footer/>
            {/* <FooterSection /> */}
        </main>
    );
};

export default HomePage;