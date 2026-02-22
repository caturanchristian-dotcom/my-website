import { Link } from 'react-router-dom';
import { 
  FileText, Shield, Users, Award, ChevronRight, Calendar, 
  Briefcase, Heart, Home as HomeIcon, CreditCard, ArrowRight,
  Phone, Clock, MapPin
} from 'lucide-react';
import { useDataStore } from '@/store/dataStore';

export function Home() {
  const { announcements, services, officials } = useDataStore();

  const quickServices = services.slice(0, 4);
  const latestNews = announcements.slice(0, 3);
  const featuredOfficials = officials.slice(0, 4);

  const iconMap: Record<string, React.ReactNode> = {
    FileText: <FileText className="w-8 h-8" />,
    Heart: <Heart className="w-8 h-8" />,
    Briefcase: <Briefcase className="w-8 h-8" />,
    Home: <HomeIcon className="w-8 h-8" />,
    CreditCard: <CreditCard className="w-8 h-8" />,
  };

  const stats = [
    { icon: <Users className="w-8 h-8" />, value: '25,000+', label: 'Residents Served' },
    { icon: <FileText className="w-8 h-8" />, value: '10,000+', label: 'Documents Issued' },
    { icon: <Shield className="w-8 h-8" />, value: '15+', label: 'Years of Service' },
    { icon: <Award className="w-8 h-8" />, value: '50+', label: 'Programs Implemented' },
  ];

  return (
    <div>
      {/* Hero Section */}
      <section className="relative min-h-[600px] flex items-center">
        <div 
          className="absolute inset-0 bg-cover bg-center"
          style={{
            backgroundImage: 'url(https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=1920)',
          }}
        />
        <div className="absolute inset-0 gradient-hero" />
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
          <div className="max-w-3xl">
            <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold text-white mb-6 text-shadow">
              Welcome to Our Barangay
            </h1>
            <p className="text-xl text-white/90 mb-8 leading-relaxed">
              Your trusted local government unit dedicated to serving our community with excellence, transparency, and integrity. Together, we build a better tomorrow.
            </p>
            <div className="flex flex-wrap gap-4">
              <Link to="/services" className="btn-primary flex items-center space-x-2">
                <span>Our Services</span>
                <ChevronRight className="w-5 h-5" />
              </Link>
              <Link to="/contact" className="btn-outline flex items-center space-x-2">
                <span>Contact Us</span>
                <Phone className="w-5 h-5" />
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Quick Info Bar */}
      <section className="bg-blue-800 text-white py-4">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-wrap justify-center md:justify-between items-center gap-4 text-sm">
            <div className="flex items-center space-x-2">
              <Clock className="w-5 h-5 text-yellow-400" />
              <span>Office Hours: Mon-Fri 8AM-5PM, Sat 8AM-12PM</span>
            </div>
            <div className="flex items-center space-x-2">
              <Phone className="w-5 h-5 text-yellow-400" />
              <span>Hotline: 0987654321</span>
            </div>
            <div className="flex items-center space-x-2">
              <MapPin className="w-5 h-5 text-yellow-400" />
              <span>Barangay Hall, Main Street</span>
            </div>
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
            {stats.map((stat, index) => (
              <div key={index} className="text-center">
                <div className="inline-flex items-center justify-center w-16 h-16 bg-blue-100 text-blue-700 rounded-full mb-4">
                  {stat.icon}
                </div>
                <div className="text-3xl font-bold text-gray-900 mb-1">{stat.value}</div>
                <div className="text-gray-600">{stat.label}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Services Section */}
      <section className="section-padding bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Our Services</h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              We provide various government services to help our residents with their needs. Request documents and certificates online.
            </p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {quickServices.map((service) => (
              <div
                key={service.id}
                className="bg-white p-6 rounded-xl shadow-md card-hover border border-gray-100"
              >
                <div className="w-14 h-14 bg-blue-100 text-blue-700 rounded-lg flex items-center justify-center mb-4">
                  {iconMap[service.icon] || <FileText className="w-8 h-8" />}
                </div>
                <h3 className="text-lg font-semibold text-gray-900 mb-2">{service.name}</h3>
                <p className="text-gray-600 text-sm mb-4 line-clamp-2">{service.description}</p>
                <div className="flex items-center justify-between text-sm">
                  <span className="text-emerald-600 font-medium">{service.fee}</span>
                  <span className="text-gray-500">{service.processingTime}</span>
                </div>
              </div>
            ))}
          </div>
          <div className="text-center mt-10">
            <Link to="/services" className="btn-primary inline-flex items-center space-x-2">
              <span>View All Services</span>
              <ArrowRight className="w-5 h-5" />
            </Link>
          </div>
        </div>
      </section>

      {/* News & Announcements */}
      <section className="section-padding bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">News & Announcements</h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Stay updated with the latest news, events, and advisories from our barangay.
            </p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {latestNews.map((news) => (
              <article
                key={news.id}
                className="bg-white rounded-xl shadow-md overflow-hidden card-hover border border-gray-100"
              >
                {news.image && (
                  <div className="h-48 overflow-hidden">
                    <img
                      src={news.image}
                      alt={news.title}
                      className="w-full h-full object-cover hover:scale-105 transition-transform duration-500"
                    />
                  </div>
                )}
                <div className="p-6">
                  <div className="flex items-center space-x-2 mb-3">
                    <span className={`px-3 py-1 text-xs font-medium rounded-full ${
                      news.category === 'event' ? 'bg-purple-100 text-purple-700' :
                      news.category === 'advisory' ? 'bg-orange-100 text-orange-700' :
                      'bg-blue-100 text-blue-700'
                    }`}>
                      {news.category.charAt(0).toUpperCase() + news.category.slice(1)}
                    </span>
                    <span className="text-gray-500 text-sm flex items-center">
                      <Calendar className="w-4 h-4 mr-1" />
                      {new Date(news.date).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })}
                    </span>
                  </div>
                  <h3 className="text-lg font-semibold text-gray-900 mb-2 line-clamp-2">{news.title}</h3>
                  <p className="text-gray-600 text-sm line-clamp-3">{news.content}</p>
                  <Link to="/news" className="inline-flex items-center mt-4 text-blue-700 font-medium hover:text-blue-800">
                    Read More <ChevronRight className="w-4 h-4 ml-1" />
                  </Link>
                </div>
              </article>
            ))}
          </div>
          <div className="text-center mt-10">
            <Link to="/news" className="btn-secondary inline-flex items-center space-x-2">
              <span>View All News</span>
              <ArrowRight className="w-5 h-5" />
            </Link>
          </div>
        </div>
      </section>

      {/* Barangay Officials */}
      <section className="section-padding bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Barangay Officials</h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Meet the dedicated leaders serving our community.
            </p>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {featuredOfficials.map((official) => (
              <div
                key={official.id}
                className="bg-white rounded-xl shadow-md overflow-hidden card-hover text-center"
              >
                <div className="h-48 overflow-hidden">
                  <img
                    src={official.image}
                    alt={official.name}
                    className="w-full h-full object-cover"
                  />
                </div>
                <div className="p-4">
                  <h3 className="font-semibold text-gray-900">{official.name}</h3>
                  <p className="text-blue-700 text-sm">{official.position}</p>
                </div>
              </div>
            ))}
          </div>
          <div className="text-center mt-10">
            <Link to="/about" className="btn-primary inline-flex items-center space-x-2">
              <span>View All Officials</span>
              <ArrowRight className="w-5 h-5" />
            </Link>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 gradient-primary">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-white mb-4">
            Need Assistance?
          </h2>
          <p className="text-white/90 text-lg mb-8 max-w-2xl mx-auto">
            Our team is ready to help you with any concerns or inquiries. Visit us at the Barangay Hall or contact us online.
          </p>
          <div className="flex flex-wrap justify-center gap-4">
            <Link to="/register" className="bg-white text-blue-700 font-semibold py-3 px-8 rounded-lg hover:bg-gray-100 transition-colors">
              Register Now
            </Link>
            <Link to="/contact" className="btn-outline">
              Contact Us
            </Link>
          </div>
        </div>
      </section>
    </div>
  );
}
