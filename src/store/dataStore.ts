import { create } from 'zustand';

export interface Announcement {
  id: number;
  title: string;
  content: string;
  date: string;
  image?: string;
  category: 'news' | 'event' | 'advisory';
}

export interface Service {
  id: number;
  name: string;
  description: string;
  requirements: string[];
  processingTime: string;
  fee: string;
  icon: string;
}

export interface ServiceRequest {
  id: number;
  userId: number;
  userName: string;
  serviceId: number;
  serviceName: string;
  status: 'pending' | 'processing' | 'completed' | 'rejected';
  date: string;
  notes?: string;
}

export interface Official {
  id: number;
  name: string;
  position: string;
  image: string;
  contact?: string;
}

interface DataState {
  announcements: Announcement[];
  services: Service[];
  serviceRequests: ServiceRequest[];
  officials: Official[];
  addAnnouncement: (announcement: Omit<Announcement, 'id'>) => void;
  updateAnnouncement: (id: number, data: Partial<Announcement>) => void;
  deleteAnnouncement: (id: number) => void;
  addServiceRequest: (request: Omit<ServiceRequest, 'id'>) => void;
  updateServiceRequest: (id: number, data: Partial<ServiceRequest>) => void;
}

export const useDataStore = create<DataState>((set) => ({
  announcements: [
    {
      id: 1,
      title: 'COVID-19 Vaccination Schedule',
      content: 'Free COVID-19 vaccination will be held at the Barangay Health Center every Monday and Wednesday from 8AM to 5PM. Please bring your valid ID and vaccination card.',
      date: '2024-01-15',
      category: 'advisory',
      image: 'https://images.unsplash.com/photo-1584036561566-baf8f5f1b144?w=800',
    },
    {
      id: 2,
      title: 'Barangay Fiesta 2024',
      content: 'Join us in celebrating our annual Barangay Fiesta on January 25, 2024. There will be various activities including sports fest, beauty pageant, and cultural shows.',
      date: '2024-01-10',
      category: 'event',
      image: 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=800',
    },
    {
      id: 3,
      title: 'Road Repair Notice',
      content: 'Road repair and maintenance will be conducted along Main Street from January 20-25. Please use alternative routes.',
      date: '2024-01-08',
      category: 'news',
      image: 'https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=800',
    },
    {
      id: 4,
      title: 'Free Legal Aid Consultation',
      content: 'The Public Attorney\'s Office will provide free legal consultation at the Barangay Hall every Friday from 9AM to 12PM.',
      date: '2024-01-05',
      category: 'advisory',
      image: 'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=800',
    },
  ],

  services: [
    {
      id: 1,
      name: 'Barangay Clearance',
      description: 'Official document certifying that the applicant is a bona fide resident of the barangay with good moral character.',
      requirements: ['Valid ID', 'Proof of Residency', '2x2 ID Photo', 'Cedula'],
      processingTime: '1-2 hours',
      fee: '₱50.00',
      icon: 'FileText',
    },
    {
      id: 2,
      name: 'Certificate of Indigency',
      description: 'Document certifying that the individual belongs to the indigent sector of the barangay.',
      requirements: ['Valid ID', 'Proof of Residency', 'Barangay Clearance'],
      processingTime: '1-2 hours',
      fee: 'Free',
      icon: 'Heart',
    },
    {
      id: 3,
      name: 'Business Permit Clearance',
      description: 'Clearance required for obtaining business permits within the barangay.',
      requirements: ['Valid ID', 'DTI Registration', 'Proof of Business Address', 'Cedula'],
      processingTime: '1-3 days',
      fee: '₱200.00',
      icon: 'Briefcase',
    },
    {
      id: 4,
      name: 'Certificate of Residency',
      description: 'Official document proving that the applicant resides within the barangay.',
      requirements: ['Valid ID', 'Utility Bill', 'Barangay Clearance'],
      processingTime: '1-2 hours',
      fee: '₱30.00',
      icon: 'Home',
    },
    {
      id: 5,
      name: 'Barangay ID',
      description: 'Official identification card for barangay residents.',
      requirements: ['Birth Certificate', 'Proof of Residency', '1x1 ID Photo'],
      processingTime: '3-5 days',
      fee: '₱100.00',
      icon: 'CreditCard',
    },
    {
      id: 6,
      name: 'Blotter Report',
      description: 'Official record of complaints or incidents reported to the barangay.',
      requirements: ['Valid ID', 'Written Statement'],
      processingTime: '30 minutes - 1 hour',
      fee: 'Free',
      icon: 'FileWarning',
    },
  ],

  serviceRequests: [
    {
      id: 1,
      userId: 2,
      userName: 'Juan Dela Cruz',
      serviceId: 1,
      serviceName: 'Barangay Clearance',
      status: 'completed',
      date: '2024-01-10',
      notes: 'Ready for pickup',
    },
    {
      id: 2,
      userId: 2,
      userName: 'Juan Dela Cruz',
      serviceId: 4,
      serviceName: 'Certificate of Residency',
      status: 'processing',
      date: '2024-01-14',
    },
  ],

  officials: [
    {
      id: 1,
      name: 'Hon. Roberto Santos',
      position: 'Punong Barangay',
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300',
      contact: '09123456789',
    },
    {
      id: 2,
      name: 'Maria Garcia',
      position: 'Barangay Secretary',
      image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300',
      contact: '09234567890',
    },
    {
      id: 3,
      name: 'Jose Reyes',
      position: 'Barangay Treasurer',
      image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300',
      contact: '09345678901',
    },
    {
      id: 4,
      name: 'Ana Martinez',
      position: 'Kagawad - Peace & Order',
      image: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=300',
    },
    {
      id: 5,
      name: 'Pedro Lopez',
      position: 'Kagawad - Health',
      image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300',
    },
    {
      id: 6,
      name: 'Elena Cruz',
      position: 'Kagawad - Education',
      image: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
    },
    {
      id: 7,
      name: 'Ricardo Fernandez',
      position: 'SK Chairman',
      image: 'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?w=300',
    },
  ],

  addAnnouncement: (announcement) =>
    set((state) => ({
      announcements: [
        { ...announcement, id: Date.now() },
        ...state.announcements,
      ],
    })),

  updateAnnouncement: (id, data) =>
    set((state) => ({
      announcements: state.announcements.map((a) =>
        a.id === id ? { ...a, ...data } : a
      ),
    })),

  deleteAnnouncement: (id) =>
    set((state) => ({
      announcements: state.announcements.filter((a) => a.id !== id),
    })),

  addServiceRequest: (request) =>
    set((state) => ({
      serviceRequests: [
        { ...request, id: Date.now() },
        ...state.serviceRequests,
      ],
    })),

  updateServiceRequest: (id, data) =>
    set((state) => ({
      serviceRequests: state.serviceRequests.map((r) =>
        r.id === id ? { ...r, ...data } : r
      ),
    })),
}));
