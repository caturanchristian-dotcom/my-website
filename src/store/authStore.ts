import { create } from 'zustand';

export interface User {
  id: number;
  email: string;
  name: string;
  role: 'admin' | 'user';
  phone?: string;
  address?: string;
  avatar?: string;
}

interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<boolean>;
  register: (data: RegisterData) => Promise<boolean>;
  logout: () => void;
  updateProfile: (data: Partial<User>) => void;
}

interface RegisterData {
  name: string;
  email: string;
  password: string;
  phone?: string;
  address?: string;
}

// Simulated users database
const users: (User & { password: string })[] = [
  {
    id: 1,
    email: 'admin@barangay.gov.ph',
    password: 'admin123',
    name: 'Barangay Admin',
    role: 'admin',
    phone: '09123456789',
    address: 'Barangay Hall, Main Street',
  },
  {
    id: 2,
    email: 'user@example.com',
    password: 'user123',
    name: 'Juan Dela Cruz',
    role: 'user',
    phone: '09987654321',
    address: '123 Residential St.',
  },
];

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  isAuthenticated: false,

  login: async (email: string, password: string) => {
    // Simulate API call
    await new Promise((resolve) => setTimeout(resolve, 1000));

    const foundUser = users.find(
      (u) => u.email === email && u.password === password
    );

    if (foundUser) {
      const { password: _, ...userWithoutPassword } = foundUser;
      set({ user: userWithoutPassword, isAuthenticated: true });
      localStorage.setItem('user', JSON.stringify(userWithoutPassword));
      return true;
    }
    return false;
  },

  register: async (data: RegisterData) => {
    // Simulate API call
    await new Promise((resolve) => setTimeout(resolve, 1000));

    const exists = users.find((u) => u.email === data.email);
    if (exists) return false;

    const newUser: User & { password: string } = {
      id: users.length + 1,
      email: data.email,
      password: data.password,
      name: data.name,
      role: 'user',
      phone: data.phone,
      address: data.address,
    };

    users.push(newUser);
    const { password: _, ...userWithoutPassword } = newUser;
    set({ user: userWithoutPassword, isAuthenticated: true });
    localStorage.setItem('user', JSON.stringify(userWithoutPassword));
    return true;
  },

  logout: () => {
    set({ user: null, isAuthenticated: false });
    localStorage.removeItem('user');
  },

  updateProfile: (data: Partial<User>) => {
    set((state) => ({
      user: state.user ? { ...state.user, ...data } : null,
    }));
  },
}));
