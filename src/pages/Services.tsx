import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { 
  FileText, Heart, Briefcase, Home, CreditCard, FileWarning, 
  CheckCircle, Clock, ChevronRight, X 
} from 'lucide-react';
import { useDataStore } from '@/store/dataStore';
import { useAuthStore } from '@/store/authStore';

export function Services() {
  const { services, addServiceRequest } = useDataStore();
  const { user, isAuthenticated } = useAuthStore();
  const navigate = useNavigate();
  const [selectedService, setSelectedService] = useState<number | null>(null);
  const [showModal, setShowModal] = useState(false);
  const [showSuccess, setShowSuccess] = useState(false);

  const iconMap: Record<string, React.ReactNode> = {
    FileText: <FileText className="w-10 h-10" />,
    Heart: <Heart className="w-10 h-10" />,
    Briefcase: <Briefcase className="w-10 h-10" />,
    Home: <Home className="w-10 h-10" />,
    CreditCard: <CreditCard className="w-10 h-10" />,
    FileWarning: <FileWarning className="w-10 h-10" />,
  };

  const handleRequestService = (serviceId: number) => {
    if (!isAuthenticated) {
      navigate('/login');
      return;
    }
    setSelectedService(serviceId);
    setShowModal(true);
  };

  const handleSubmitRequest = () => {
    const service = services.find((s) => s.id === selectedService);
    if (service && user) {
      addServiceRequest({
        userId: user.id,
        userName: user.name,
        serviceId: service.id,
        serviceName: service.name,
        status: 'pending',
        date: new Date().toISOString().split('T')[0],
      });
      setShowModal(false);
      setShowSuccess(true);
      setTimeout(() => setShowSuccess(false), 3000);
    }
  };

  const selectedServiceData = services.find((s) => s.id === selectedService);

  return (
    <div>
      {/* Hero */}
      <section className="relative py-20 gradient-primary">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-4xl md:text-5xl font-bold text-white mb-4">Our Services</h1>
          <p className="text-white/90 text-lg max-w-2xl mx-auto">
            We offer various government services to help our residents. Request documents and certificates easily.
          </p>
        </div>
      </section>

      {/* Services Grid */}
      <section className="section-padding bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {services.map((service) => (
              <div
                key={service.id}
                className="bg-white rounded-xl shadow-lg overflow-hidden card-hover"
              >
                <div className="p-6">
                  <div className="w-16 h-16 bg-blue-100 text-blue-700 rounded-xl flex items-center justify-center mb-4">
                    {iconMap[service.icon] || <FileText className="w-10 h-10" />}
                  </div>
                  <h3 className="text-xl font-bold text-gray-900 mb-2">{service.name}</h3>
                  <p className="text-gray-600 mb-4">{service.description}</p>
                  
                  <div className="space-y-3 mb-4">
                    <div className="flex items-center space-x-2 text-sm">
                      <Clock className="w-4 h-4 text-blue-600" />
                      <span className="text-gray-600">Processing: {service.processingTime}</span>
                    </div>
                    <div className="flex items-center space-x-2 text-sm">
                      <span className="font-semibold text-emerald-600 text-lg">{service.fee}</span>
                    </div>
                  </div>

                  <div className="border-t pt-4">
                    <p className="text-sm font-medium text-gray-700 mb-2">Requirements:</p>
                    <ul className="space-y-1">
                      {service.requirements.slice(0, 3).map((req, index) => (
                        <li key={index} className="flex items-start space-x-2 text-sm text-gray-600">
                          <CheckCircle className="w-4 h-4 text-emerald-500 mt-0.5 flex-shrink-0" />
                          <span>{req}</span>
                        </li>
                      ))}
                      {service.requirements.length > 3 && (
                        <li className="text-sm text-blue-600">+{service.requirements.length - 3} more</li>
                      )}
                    </ul>
                  </div>
                </div>
                <div className="px-6 pb-6">
                  <button
                    onClick={() => handleRequestService(service.id)}
                    className="w-full btn-primary flex items-center justify-center space-x-2"
                  >
                    <span>Request Service</span>
                    <ChevronRight className="w-5 h-5" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* How to Request */}
      <section className="section-padding bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">How to Request a Service</h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Follow these simple steps to request any service from our barangay.
            </p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            {[
              { step: 1, title: 'Register/Login', desc: 'Create an account or login to the portal' },
              { step: 2, title: 'Select Service', desc: 'Choose the service you need from the list' },
              { step: 3, title: 'Submit Request', desc: 'Fill out the form and submit your request' },
              { step: 4, title: 'Claim Document', desc: 'Visit the barangay hall to claim your document' },
            ].map((item) => (
              <div key={item.step} className="text-center">
                <div className="w-16 h-16 bg-blue-700 text-white rounded-full flex items-center justify-center mx-auto mb-4 text-2xl font-bold">
                  {item.step}
                </div>
                <h3 className="text-lg font-semibold text-gray-900 mb-2">{item.title}</h3>
                <p className="text-gray-600 text-sm">{item.desc}</p>
              </div>
            ))}
          </div>
          <div className="text-center mt-10">
            {!isAuthenticated && (
              <Link to="/register" className="btn-primary">
                Register Now to Get Started
              </Link>
            )}
          </div>
        </div>
      </section>

      {/* Request Modal */}
      {showModal && selectedServiceData && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl max-w-md w-full p-6 animate-fade-in">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-xl font-bold text-gray-900">Request Service</h3>
              <button onClick={() => setShowModal(false)} className="p-2 hover:bg-gray-100 rounded-lg">
                <X className="w-5 h-5" />
              </button>
            </div>
            <div className="mb-6">
              <div className="bg-blue-50 p-4 rounded-lg mb-4">
                <h4 className="font-semibold text-blue-700">{selectedServiceData.name}</h4>
                <p className="text-sm text-gray-600 mt-1">{selectedServiceData.description}</p>
              </div>
              <div className="space-y-3">
                <div className="flex justify-between text-sm">
                  <span className="text-gray-600">Processing Time:</span>
                  <span className="font-medium">{selectedServiceData.processingTime}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-600">Fee:</span>
                  <span className="font-medium text-emerald-600">{selectedServiceData.fee}</span>
                </div>
              </div>
              <div className="mt-4">
                <p className="text-sm font-medium text-gray-700 mb-2">Requirements to bring:</p>
                <ul className="space-y-1">
                  {selectedServiceData.requirements.map((req, index) => (
                    <li key={index} className="flex items-start space-x-2 text-sm text-gray-600">
                      <CheckCircle className="w-4 h-4 text-emerald-500 mt-0.5 flex-shrink-0" />
                      <span>{req}</span>
                    </li>
                  ))}
                </ul>
              </div>
            </div>
            <div className="flex space-x-3">
              <button
                onClick={() => setShowModal(false)}
                className="flex-1 py-3 border border-gray-300 rounded-lg font-medium hover:bg-gray-50 transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={handleSubmitRequest}
                className="flex-1 btn-primary"
              >
                Submit Request
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Success Toast */}
      {showSuccess && (
        <div className="fixed bottom-4 right-4 bg-emerald-600 text-white px-6 py-4 rounded-lg shadow-lg flex items-center space-x-2 animate-fade-in z-50">
          <CheckCircle className="w-5 h-5" />
          <span>Service request submitted successfully!</span>
        </div>
      )}
    </div>
  );
}
