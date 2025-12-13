export default function NutritionHero() {
  return (
    <header
      id="home"
      className={`min-h-screen relative w-full flex items-center overflow-hidden`}
      aria-label="Nutrition app hero"
    >
      {/* Background */}
      <div
        className="absolute inset-0 bg-cover bg-no-repeat bg-top"
        style={{ backgroundImage: "url('/images/main-bg.png')" }}
      />

      {/* Gradient */}
      {/* <div className="absolute inset-0 bg-gradient-to-r from-white/90 via-white/70 to-transparent" /> */}

      <div className="relative container mx-auto px-6 lg:px-12 py-20">
        <div className="max-w-xl">
          <h1 className="text-4xl md:text-5xl font-extrabold text-gray-900 leading-tight drop-shadow-md">
            Play Healthy. <br />
            Sync Your Plate. <br />
            Shape Your Life.
          </h1>
          <p className="mt-4 text-gray-700 text-lg drop-shadow">
            Personalised meal plans, AI food recognition, and daily nutrition
            insights - all in one app.
          </p>
        </div>
        {/* small feature bullets */}
        <div>
          <ul className="mt-8 grid grid-cols-1 sm:grid-cols-1 gap-2 text-sm text-gray-600">
            <li className="flex items-center gap-3">
              <span className="flex-none h-8 w-8 rounded-full bg-emerald-50 grid place-items-center text-emerald-600 font-semibold">
                ✓
              </span>
              <span>AI food recognition & meal logging</span>
            </li>
            <li className="flex items-center gap-2">
              <span className="flex-none h-8 w-8 rounded-full bg-amber-50 grid place-items-center text-amber-600 font-semibold">
                ✓
              </span>
              <span>Custom meal plans & risk predictions</span>
            </li>
          </ul>
        </div>
      </div>
    </header>
  );
}
