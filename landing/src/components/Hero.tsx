import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { ShoppingBag } from 'lucide-react';

const screenshots = [
  '/screenshots/1.png',
  '/screenshots/2.png',
  '/screenshots/3.png',
  '/screenshots/4.png',
  '/screenshots/5.png',
  '/screenshots/6.png',
  '/screenshots/7.png',
  '/screenshots/8.png',
  '/screenshots/9.png',
  '/screenshots/10.png',
];

const GooglePlayLogo = () => (
  <svg viewBox="0 0 512 512" width="20" height="20" xmlns="http://www.w3.org/2000/svg">
    <path d="M325.3 234.3L104.6 13l280.8 161.2-60.1 60.1z" fill="#FF3A44"/>
    <path d="M25.3 35.3v441.3c0 16.1 8.7 28.5 21.7 35.3l256.6-256L47 0C34 6.8 25.3 19.2 25.3 35.3z" fill="#00A0FF"/>
    <path d="M325.3 277.7l-60.1-60.1L104.6 499l280.8-161.2-60.1-60.1z" fill="#00E061"/>
    <path d="M460.1 225.6l-58.9-34.1-65.7 64.5 65.7 64.5 60.1-34.1c18-10.3 18-28.5-1.2-40.8z" fill="#FFC107"/>
  </svg>
);

const Hero = () => {
  const [currentIndex, setCurrentIndex] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentIndex((prev) => (prev + 1) % screenshots.length);
    }, 3000);
    return () => clearInterval(timer);
  }, []);

  const isMobile = typeof window !== 'undefined' ? window.innerWidth <= 768 : false;

  return (
    <section className="hero-overflow">
      <div className="shimmer-overlay"></div>
      <div className="container hero-container">
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
          className="hero-content"
        >
          <motion.div 
            className="badge"
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ delay: 0.2, type: "spring", stiffness: 200 }}
          >
            <span>✨ New: Family & Staff Links</span>
          </motion.div>
          
          <h1 className="hero-title">
            Run your store with confidence<br />
            <span className="shimmer-text">even when Mama isn't around.</span>
          </h1>
          
          <p className="hero-subtitle">
            Find product prices, shelf locations, and stock storage instantly. No more guessing. No more Messenger chats while customers wait.
          </p>
          
          <div className="hero-actions">
            <motion.button 
              whileHover={{ scale: 1.05, boxShadow: "0 10px 25px -5px rgba(30, 136, 229, 0.4)" }}
              whileTap={{ scale: 0.95 }}
              className="btn-primary"
              onClick={() => window.open('https://play.google.com/store/apps/details?id=com.aebibtech.tindahan_natin', '_blank')}
            >
              <GooglePlayLogo /> Get it on Google Play
            </motion.button>
            {/* <motion.button 
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className="btn-secondary"
            >
              View Demo
            </motion.button> */}
          </div>
        </motion.div>

        <motion.div 
          initial={{ opacity: 0, x: isMobile ? 0 : 50, y: isMobile ? 20 : 0 }}
          animate={{ opacity: 1, x: 0, y: 0 }}
          transition={{ duration: 1, delay: 0.4 }}
          className="hero-visual"
        >
          <div className="phone-mockup">
            <div className="phone-notch"></div>
            <div className="phone-screen">
              <AnimatePresence mode="wait">
                <motion.img
                  key={currentIndex}
                  src={screenshots[currentIndex]}
                  initial={{ opacity: 0, scale: 0.95 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 1.05 }}
                  transition={{ duration: 0.4 }}
                  className="screenshot-img"
                  alt={`Screenshot ${currentIndex + 1}`}
                />
              </AnimatePresence>
            </div>
            <motion.div 
               animate={{ 
                 y: [0, -10, 0],
                 rotate: [0, 5, 0]
               }}
               transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
               className="floating-icon icon-1"
            >
              <ShoppingBag color="#FFB300" size={32} fill="#FFB300" />
            </motion.div>
          </div>
        </motion.div>
      </div>

      <style>{`
        .hero-overflow {
          position: relative;
          padding: 8rem 0;
          background: var(--background);
          overflow: hidden;
        }

        .shimmer-overlay {
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: radial-gradient(circle at 50% 50%, rgba(30, 136, 229, 0.03) 0%, transparent 70%);
          pointer-events: none;
        }

        .hero-container {
          display: grid;
          grid-template-columns: 1.2fr 1fr;
          align-items: center;
          gap: 4rem;
        }

        @media (max-width: 768px) {
          .hero-overflow {
            padding: 4rem 0;
          }
          .hero-container {
            grid-template-columns: 1fr;
            text-align: center;
            gap: 3rem;
          }
          .hero-content {
            display: flex;
            flex-direction: column;
            align-items: center;
          }
          .hero-title {
            font-size: 2.75rem;
            text-align: center;
          }
          .hero-subtitle {
            font-size: 1.125rem;
            margin-left: auto;
            margin-right: auto;
            text-align: center;
          }
          .hero-actions {
            flex-direction: column;
            align-items: center;
            gap: 0.75rem;
            width: 100%;
          }
          .btn-primary, .btn-secondary {
            width: 100%;
            max-width: 320px;
            justify-content: center;
          }
          .phone-mockup {
            width: 240px;
            height: 500px;
            border-radius: 40px;
          }
          .phone-screen {
            border-radius: 32px;
          }
          .icon-1 {
            right: -20px;
          }
        }

        @media (max-width: 480px) {
          .hero-title {
            font-size: 10vw!important;
          }

          .hero-container {
            padding: 0 1rem;
          }
        }

        .badge {
          display: inline-block;
          padding: 0.5rem 1rem;
          background: rgba(30, 136, 229, 0.1);
          color: #1E88E5;
          border-radius: 99px;
          font-weight: 700;
          font-size: 0.875rem;
          margin-bottom: 1.5rem;
        }

        .hero-title {
          font-size: 4rem;
          font-weight: 900;
          line-height: 1.05;
          margin: 0 0 1.5rem;
          color: var(--text);
          letter-spacing: -0.02em;
        }

        .shimmer-text {
          background: linear-gradient(90deg, #1E88E5, #FFB300, #1E88E5);
          background-size: 200% auto;
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          animation: shimmer 4s linear infinite;
        }

        @keyframes shimmer {
          to { background-position: 200% center; }
        }

        .hero-subtitle {
          font-size: 1.25rem;
          line-height: 1.6;
          color: var(--text-light);
          margin-bottom: 2.5rem;
          max-width: 540px;
        }

        .hero-actions {
          display: flex;
          gap: 1rem;
        }

        .btn-primary {
          background: #1E88E5;
          color: white;
          border: none;
          padding: 1rem 2rem;
          border-radius: 12px;
          font-weight: 700;
          font-size: 1.1rem;
          cursor: pointer;
          display: flex;
          align-items: center;
          gap: 0.5rem;
        }

        .btn-secondary {
          background: var(--card-bg);
          color: var(--primary);
          border: 2px solid var(--border);
          padding: 1rem 2rem;
          border-radius: 12px;
          font-weight: 700;
          font-size: 1.1rem;
          cursor: pointer;
        }

        .phone-mockup {
          position: relative;
          width: 280px;
          height: 580px;
          background: #000;
          border-radius: 48px;
          border: 10px solid var(--phone-frame);
          box-shadow: var(--phone-shadow);
          margin: 0 auto;
          display: flex;
          align-items: center;
          justify-content: center;
        }

        .phone-notch {
          position: absolute;
          top: 15px;
          width: 15px;
          height: 15px;
          background: var(--phone-frame);
          border-radius: 20px;
          z-index: 10;
        }

        .phone-screen {
          width: 100%;
          height: 100%;
          background: var(--card-bg);
          border-radius: 38px;
          overflow: hidden;
          position: relative;
          border: 2px solid #000;
        }

        .screenshot-img {
          width: 100%;
          height: 100%;
          object-fit: cover;
          object-position: top;
          position: absolute;
          top: 0;
          left: 0;
        }

        .floating-icon {
          position: absolute;
          background: var(--card-bg);
          padding: 1rem;
          border-radius: 20px;
          box-shadow: var(--card-shadow);
        }

        .icon-1 {
          top: 20%;
          right: -40px;
        }
      `}</style>
    </section>
  );
};

export default Hero;
