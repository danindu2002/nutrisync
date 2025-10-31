import { HeroGeometric } from '@/components/Hero';
import React from 'react';
import FooterSection from '@/components/SiteFooter';

const HomePage: React.FC = () => {
    return (
        <main className="flex flex-col items-center justify-center min-h-screen">
            <HeroGeometric />
            <FooterSection />
        </main>
    );
};

export default HomePage;