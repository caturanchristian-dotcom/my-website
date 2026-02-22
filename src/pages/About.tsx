import { Target, Eye, Heart, Award, Users, Shield } from 'lucide-react';
import { useDataStore } from '@/store/dataStore';

export function About() {
  const { officials } = useDataStore();

  const values = [
    { icon: <Heart className="w-6 h-6" />, title: 'Service', description: 'Dedicated to serving our community with compassion and excellence.' },
    { icon: <Shield className="w-6 h-6" />, title: 'Integrity', description: 'Upholding honesty and transparency in all our dealings.' },
    { icon: <Users className="w-6 h-6" />, title: 'Unity', description: 'Working together as one community towards common goals.' },
    { icon: <Award className="w-6 h-6" />, title: 'Excellence', description: 'Striving for the highest standards in public service.' },
  ];

  return (
    <div>
      {/* Hero */}
      <section className="relative py-20 gradient-primary">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-4xl md:text-5xl font-bold text-white mb-4">About Our Barangay</h1>
          <p className="text-white/90 text-lg max-w-2xl mx-auto">
            Learn about our history, vision, mission, and the dedicated leaders serving our community.
          </p>
        </div>
      </section>

      {/* History */}
      <section className="section-padding bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-2 gap-12 items-center">
            <div>
              <h2 className="text-3xl font-bold text-gray-900 mb-6">Our History</h2>
              <div className="space-y-4 text-gray-600 leading-relaxed">
                <p>
                  Our barangay was established in 1950, starting as a small community of farmers and fishermen. 
                  Over the decades, it has grown into a thriving urban barangay with a diverse population.
                </p>
                <p>
                  Through the years, we have witnessed significant development and progress, from dirt roads 
                  to paved streets, from small huts to modern structures, all while maintaining the strong 
                  sense of community that defines who we are.
                </p>
                <p>
                  Today, we continue to build upon the foundation laid by our predecessors, embracing 
                  modernization while preserving our cultural heritage and values.
                </p>
              </div>
            </div>
            <div className="rounded-xl overflow-hidden shadow-xl">
              <img
                src="https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800"
                alt="Community"
                className="w-full h-80 object-cover"
              />
            </div>
          </div>
        </div>
      </section>

      {/* Vision & Mission */}
      <section className="section-padding bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-2 gap-8">
            <div className="bg-white p-8 rounded-xl shadow-lg border-t-4 border-blue-700">
              <div className="flex items-center space-x-3 mb-4">
                <div className="w-12 h-12 bg-blue-100 text-blue-700 rounded-lg flex items-center justify-center">
                  <Eye className="w-6 h-6" />
                </div>
                <h3 className="text-2xl font-bold text-gray-900">Our Vision</h3>
              </div>
              <p className="text-gray-600 leading-relaxed">
                A progressive, peaceful, and self-reliant barangay where every resident enjoys a high quality 
                of life, with access to essential services, opportunities for growth, and a clean and safe 
                environment for all.
              </p>
            </div>
            <div className="bg-white p-8 rounded-xl shadow-lg border-t-4 border-emerald-600">
              <div className="flex items-center space-x-3 mb-4">
                <div className="w-12 h-12 bg-emerald-100 text-emerald-700 rounded-lg flex items-center justify-center">
                  <Target className="w-6 h-6" />
                </div>
                <h3 className="text-2xl font-bold text-gray-900">Our Mission</h3>
              </div>
              <p className="text-gray-600 leading-relaxed">
                To deliver efficient and transparent public services, promote sustainable development, 
                maintain peace and order, and empower our residents to actively participate in 
                community-building and governance.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Core Values */}
      <section className="section-padding bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">Our Core Values</h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              These values guide our actions and decisions as we serve our community.
            </p>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {values.map((value, index) => (
              <div key={index} className="bg-gray-50 p-6 rounded-xl text-center card-hover">
                <div className="w-14 h-14 bg-blue-700 text-white rounded-full flex items-center justify-center mx-auto mb-4">
                  {value.icon}
                </div>
                <h3 className="text-lg font-semibold text-gray-900 mb-2">{value.title}</h3>
                <p className="text-gray-600 text-sm">{value.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Barangay Officials */}
      <section className="section-padding bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">Barangay Officials</h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Meet the dedicated public servants leading our barangay.
            </p>
          </div>
          
          {/* Punong Barangay */}
          <div className="flex justify-center mb-10">
            <div className="bg-white rounded-xl shadow-lg overflow-hidden max-w-sm w-full text-center card-hover">
              <div className="h-64 overflow-hidden">
                <img
                  src={officials[0]?.image}
                  alt={officials[0]?.name}
                  className="w-full h-full object-cover"
                />
              </div>
              <div className="p-6">
                <h3 className="text-xl font-bold text-gray-900">{officials[0]?.name}</h3>
                <p className="text-blue-700 font-medium">{officials[0]?.position}</p>
                {officials[0]?.contact && (
                  <p className="text-gray-500 text-sm mt-2">Contact: {officials[0]?.contact}</p>
                )}
              </div>
            </div>
          </div>

          {/* Other Officials */}
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            {officials.slice(1).map((official) => (
              <div
                key={official.id}
                className="bg-white rounded-xl shadow-md overflow-hidden text-center card-hover"
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
        </div>
      </section>

      {/* Organizational Structure */}
      <section className="section-padding bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">Organizational Structure</h2>
          </div>
          <div className="bg-gray-50 p-8 rounded-xl">
            <div className="flex flex-col items-center space-y-4">
              <div className="bg-blue-700 text-white px-8 py-4 rounded-lg font-semibold text-center">
                Punong Barangay
              </div>
              <div className="w-0.5 h-8 bg-gray-300"></div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="bg-blue-600 text-white px-6 py-3 rounded-lg font-medium text-center">
                  Barangay Secretary
                </div>
                <div className="bg-blue-600 text-white px-6 py-3 rounded-lg font-medium text-center">
                  Barangay Treasurer
                </div>
              </div>
              <div className="w-0.5 h-8 bg-gray-300"></div>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                {['Peace & Order', 'Health', 'Education', 'Environment'].map((committee) => (
                  <div key={committee} className="bg-blue-500 text-white px-4 py-2 rounded-lg text-sm text-center">
                    {committee}
                  </div>
                ))}
              </div>
              <div className="w-0.5 h-8 bg-gray-300"></div>
              <div className="bg-purple-600 text-white px-8 py-4 rounded-lg font-semibold text-center">
                Sangguniang Kabataan (SK)
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
