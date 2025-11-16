import { Calendar, Utensils, ShoppingCart } from "lucide-react";
import featureCalendar from "@/assets/feature-calendar.jpg";
import featureRecipes from "@/assets/feature-recipes.jpg";
import featureShopping from "@/assets/feature-shopping.jpg";

const features = [
  {
    icon: Calendar,
    title: "Smart Meal Planning",
    description: "AI-powered weekly meal plans tailored to your dietary preferences, goals, and lifestyle.",
    image: featureCalendar,
  },
  {
    icon: Utensils,
    title: "Delicious Recipes",
    description: "Access thousands of nutritious recipes with step-by-step instructions and nutritional info.",
    image: featureRecipes,
  },
  {
    icon: ShoppingCart,
    title: "Auto Shopping Lists",
    description: "Generate organized grocery lists automatically from your meal plans. Save time and money.",
    image: featureShopping,
  },
];

export const Features = () => {
  return (
    <section className="py-20 bg-muted/30">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-bold mb-4">Everything You Need to Eat Well</h2>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Powerful features designed to make healthy eating effortless and enjoyable
          </p>
        </div>
        
        <div className="grid md:grid-cols-3 gap-8">
          {features.map((feature, index) => (
            <div
              key={index}
              className="bg-card rounded-2xl p-8 shadow-sm hover:shadow-lg transition-all duration-300 border border-border hover:border-primary/20"
            >
              <div className="w-24 h-24 mx-auto mb-6 rounded-xl overflow-hidden">
                <img 
                  src={feature.image} 
                  alt={feature.title}
                  className="w-full h-full object-cover"
                />
              </div>
              <feature.icon className="w-12 h-12 text-primary mx-auto mb-4" />
              <h3 className="text-2xl font-semibold mb-3 text-center">{feature.title}</h3>
              <p className="text-muted-foreground text-center leading-relaxed">
                {feature.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};