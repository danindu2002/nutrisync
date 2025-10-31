import React from 'react';
import './globals.css';

const RootLayout: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  return (
    <html lang="en">
      <head>
        <title>NutriSync</title>
      </head>
      <body>
        {children}
      </body>
    </html>
  );
};

export default RootLayout;