import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { 
  User, FileText, Clock, CheckCircle, XCircle, AlertCircle,
  LogOut, Home, Settings, Bell, Users, Megaphone, Plus, Trash2, Edit2, Save, X
} from 'lucide-react';
import { useAuthStore } from '@/store/authStore';
import { useDataStore, Announcement } from '@/store/dataStore';

export function AdminDashboard() {
  const { user, logout } = useAuthStore();
  const { 
    serviceRequests, announcements, updateServiceRequest, 
    addAnnouncement, updateAnnouncement, deleteAnnouncement 
  } = useDataStore();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState('overview');
  const [showAnnouncementModal, setShowAnnouncementModal] = useState(false);
  const [editingAnnouncement, setEditingAnnouncement] = useState<Announcement | null>(null);
  const [announcementForm, setAnnouncementForm] = useState({
    title: '',
    content: '',
    category: 'news' as 'news' | 'event' | 'advisory',
    image: '',
  });

  if (!user || user.role !== 'admin') {
    navigate('/login');
    return null;
  }

  const pendingRequests = serviceRequests.filter((r) => r.status === 'pending').length;
  const processingRequests = serviceRequests.filter((r) => r.status === 'processing').length;
  const completedRequests = serviceRequests.filter((r) => r.status === 'completed').length;
  const totalRequests = serviceRequests.length;

  const handleLogout = () => {
    logout();
    navigate('/');
  };

  const handleUpdateStatus = (id: number, status: 'pending' | 'processing' | 'completed' | 'rejected', notes?: string) => {
    updateServiceRequest(id, { status, notes });
  };

  const handleSaveAnnouncement = () => {
    if (editingAnnouncement) {
      updateAnnouncement(editingAnnouncement.id, {
        ...announcementForm,
        date: editingAnnouncement.date,
      });
    } else {
      addAnnouncement({
        ...announcementForm,
        date: new Date().toISOString().split('T')[0],
      });
    }
    setShowAnnouncementModal(false);
    setEditingAnnouncement(null);
    setAnnouncementForm({ title: '', content: '', category: 'news', image: '' });
  };

  const handleEditAnnouncement = (announcement: Announcement) => {
    setEditingAnnouncement(announcement);
    setAnnouncementForm({
      title: announcement.title,
      content: announcement.content,
      category: announcement.category,
      image: announcement.image || '',
    });
    setShowAnnouncementModal(true);
  };

  const getStatusClass = (status: string) => {
    switch (status) {
      case 'pending':
        return 'bg-yellow-100 text-yellow-700';
      case 'processing':
        return 'bg-blue-100 text-blue-700';
      case 'completed':
        return 'bg-emerald-100 text-emerald-700';
      case 'rejected':
        return 'bg-red-100 text-red-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  return (
    <div className="min-h-screen bg-gray-100">
      {/* Sidebar */}
      <aside className="fixed left-0 top-0 h-full w-64 bg-blue-900 text-white z-40 hidden lg:block">
        <div className="p-6 border-b border-blue-800">
          <Link to="/" className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-white rounded-full flex items-center justify-center">
              <span className="text-blue-900 font-bold">B</span>
            </div>
            <div>
              <span className="text-lg font-bold">BARANGAY</span>
              <p className="text-xs text-blue-300">Admin Panel</p>
            </div>
          </Link>
        </div>

        <div className="p-4">
          <div className="flex items-center space-x-3 p-3 bg-blue-800 rounded-lg mb-6">
            <div className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center">
              <span className="font-bold">{user.name.charAt(0).toUpperCase()}</span>
            </div>
            <div>
              <p className="font-semibold text-sm">{user.name}</p>
              <p className="text-xs text-blue-300">Administrator</p>
            </div>
          </div>

          <nav className="space-y-1">
            {[
              { id: 'overview', icon: Home, label: 'Overview' },
              { id: 'requests', icon: FileText, label: 'Service Requests' },
              { id: 'announcements', icon: Megaphone, label: 'Announcements' },
              { id: 'users', icon: Users, label: 'Users' },
              { id: 'settings', icon: Settings, label: 'Settings' },
            ].map((item) => (
              <button
                key={item.id}
                onClick={() => setActiveTab(item.id)}
                className={`w-full flex items-center space-x-3 px-4 py-3 rounded-lg transition-colors ${
                  activeTab === item.id ? 'bg-white text-blue-900' : 'text-white hover:bg-blue-800'
                }`}
              >
                <item.icon className="w-5 h-5" />
                <span>{item.label}</span>
              </button>
            ))}
          </nav>
        </div>

        <div className="absolute bottom-0 left-0 right-0 p-4 border-t border-blue-800">
          <button
            onClick={handleLogout}
            className="w-full flex items-center space-x-3 px-4 py-3 text-red-300 hover:bg-red-500/20 rounded-lg transition-colors"
          >
            <LogOut className="w-5 h-5" />
            <span>Logout</span>
          </button>
        </div>
      </aside>

      {/* Main Content */}
      <main className="lg:ml-64 min-h-screen">
        {/* Top Bar */}
        <header className="bg-white shadow-sm sticky top-0 z-30">
          <div className="flex items-center justify-between px-6 py-4">
            <h1 className="text-xl font-bold text-gray-800">
              {activeTab === 'overview' && 'Admin Dashboard'}
              {activeTab === 'requests' && 'Manage Service Requests'}
              {activeTab === 'announcements' && 'Manage Announcements'}
              {activeTab === 'users' && 'Manage Users'}
              {activeTab === 'settings' && 'System Settings'}
            </h1>
            <div className="flex items-center space-x-4">
              <button className="relative p-2 hover:bg-gray-100 rounded-lg">
                <Bell className="w-6 h-6 text-gray-600" />
                <span className="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
              </button>
              <Link to="/" className="text-blue-700 hover:text-blue-800 font-medium">
                View Website
              </Link>
            </div>
          </div>
        </header>

        <div className="p-6">
          {/* Mobile Nav */}
          <div className="lg:hidden flex space-x-2 mb-6 overflow-x-auto pb-2">
            {['overview', 'requests', 'announcements', 'users'].map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`px-4 py-2 rounded-lg whitespace-nowrap ${
                  activeTab === tab
                    ? 'bg-blue-700 text-white'
                    : 'bg-white text-gray-700 hover:bg-gray-100'
                }`}
              >
                {tab.charAt(0).toUpperCase() + tab.slice(1)}
              </button>
            ))}
          </div>

          {/* Overview Tab */}
          {activeTab === 'overview' && (
            <div className="space-y-6">
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                <div className="bg-gradient-to-br from-yellow-400 to-yellow-500 p-6 rounded-xl text-white">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-yellow-100">Pending</p>
                      <p className="text-3xl font-bold mt-1">{pendingRequests}</p>
                    </div>
                    <Clock className="w-12 h-12 text-yellow-200" />
                  </div>
                </div>
                <div className="bg-gradient-to-br from-blue-500 to-blue-600 p-6 rounded-xl text-white">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-blue-100">Processing</p>
                      <p className="text-3xl font-bold mt-1">{processingRequests}</p>
                    </div>
                    <AlertCircle className="w-12 h-12 text-blue-200" />
                  </div>
                </div>
                <div className="bg-gradient-to-br from-emerald-500 to-emerald-600 p-6 rounded-xl text-white">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-emerald-100">Completed</p>
                      <p className="text-3xl font-bold mt-1">{completedRequests}</p>
                    </div>
                    <CheckCircle className="w-12 h-12 text-emerald-200" />
                  </div>
                </div>
                <div className="bg-gradient-to-br from-purple-500 to-purple-600 p-6 rounded-xl text-white">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-purple-100">Total Requests</p>
                      <p className="text-3xl font-bold mt-1">{totalRequests}</p>
                    </div>
                    <FileText className="w-12 h-12 text-purple-200" />
                  </div>
                </div>
              </div>

              <div className="grid lg:grid-cols-2 gap-6">
                <div className="bg-white p-6 rounded-xl shadow-sm">
                  <h2 className="text-lg font-semibold text-gray-900 mb-4">Recent Requests</h2>
                  <div className="space-y-3">
                    {serviceRequests.slice(0, 5).map((request) => (
                      <div key={request.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                        <div>
                          <p className="font-medium text-gray-900">{request.serviceName}</p>
                          <p className="text-sm text-gray-500">{request.userName} • {request.date}</p>
                        </div>
                        <span className={`px-3 py-1 text-xs font-medium rounded-full ${getStatusClass(request.status)}`}>
                          {request.status.charAt(0).toUpperCase() + request.status.slice(1)}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>

                <div className="bg-white p-6 rounded-xl shadow-sm">
                  <h2 className="text-lg font-semibold text-gray-900 mb-4">Recent Announcements</h2>
                  <div className="space-y-3">
                    {announcements.slice(0, 4).map((announcement) => (
                      <div key={announcement.id} className="p-3 bg-gray-50 rounded-lg">
                        <div className="flex items-center justify-between">
                          <span className={`px-2 py-0.5 text-xs font-medium rounded ${
                            announcement.category === 'event' ? 'bg-purple-100 text-purple-700' :
                            announcement.category === 'advisory' ? 'bg-orange-100 text-orange-700' :
                            'bg-blue-100 text-blue-700'
                          }`}>
                            {announcement.category}
                          </span>
                          <span className="text-xs text-gray-500">{announcement.date}</span>
                        </div>
                        <p className="font-medium text-gray-900 mt-2 line-clamp-1">{announcement.title}</p>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Requests Tab */}
          {activeTab === 'requests' && (
            <div className="bg-white rounded-xl shadow-sm overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                        Resident
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                        Service
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                        Date
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                        Status
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                        Actions
                      </th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-200">
                    {serviceRequests.map((request) => (
                      <tr key={request.id} className="hover:bg-gray-50">
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="flex items-center">
                            <div className="w-8 h-8 bg-blue-100 text-blue-700 rounded-full flex items-center justify-center mr-3">
                              <User className="w-4 h-4" />
                            </div>
                            <span className="font-medium text-gray-900">{request.userName}</span>
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-gray-600">
                          {request.serviceName}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-gray-600">
                          {request.date}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <select
                            value={request.status}
                            onChange={(e) => handleUpdateStatus(request.id, e.target.value as any)}
                            className={`px-3 py-1 text-sm font-medium rounded-full border-0 ${getStatusClass(request.status)}`}
                          >
                            <option value="pending">Pending</option>
                            <option value="processing">Processing</option>
                            <option value="completed">Completed</option>
                            <option value="rejected">Rejected</option>
                          </select>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <button
                            onClick={() => handleUpdateStatus(request.id, 'completed', 'Ready for pickup')}
                            className="text-emerald-600 hover:text-emerald-700 mr-3"
                            title="Mark Complete"
                          >
                            <CheckCircle className="w-5 h-5" />
                          </button>
                          <button
                            onClick={() => handleUpdateStatus(request.id, 'rejected', 'Incomplete requirements')}
                            className="text-red-600 hover:text-red-700"
                            title="Reject"
                          >
                            <XCircle className="w-5 h-5" />
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* Announcements Tab */}
          {activeTab === 'announcements' && (
            <div className="space-y-6">
              <div className="flex justify-end">
                <button
                  onClick={() => {
                    setEditingAnnouncement(null);
                    setAnnouncementForm({ title: '', content: '', category: 'news', image: '' });
                    setShowAnnouncementModal(true);
                  }}
                  className="btn-primary flex items-center space-x-2"
                >
                  <Plus className="w-5 h-5" />
                  <span>Add Announcement</span>
                </button>
              </div>

              <div className="bg-white rounded-xl shadow-sm overflow-hidden">
                <table className="w-full">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                        Title
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                        Category
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                        Date
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                        Actions
                      </th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-200">
                    {announcements.map((announcement) => (
                      <tr key={announcement.id} className="hover:bg-gray-50">
                        <td className="px-6 py-4">
                          <p className="font-medium text-gray-900">{announcement.title}</p>
                          <p className="text-sm text-gray-500 line-clamp-1">{announcement.content}</p>
                        </td>
                        <td className="px-6 py-4">
                          <span className={`px-3 py-1 text-xs font-medium rounded-full ${
                            announcement.category === 'event' ? 'bg-purple-100 text-purple-700' :
                            announcement.category === 'advisory' ? 'bg-orange-100 text-orange-700' :
                            'bg-blue-100 text-blue-700'
                          }`}>
                            {announcement.category}
                          </span>
                        </td>
                        <td className="px-6 py-4 text-gray-600">
                          {announcement.date}
                        </td>
                        <td className="px-6 py-4">
                          <button
                            onClick={() => handleEditAnnouncement(announcement)}
                            className="text-blue-600 hover:text-blue-700 mr-3"
                          >
                            <Edit2 className="w-5 h-5" />
                          </button>
                          <button
                            onClick={() => deleteAnnouncement(announcement.id)}
                            className="text-red-600 hover:text-red-700"
                          >
                            <Trash2 className="w-5 h-5" />
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* Users Tab */}
          {activeTab === 'users' && (
            <div className="bg-white rounded-xl shadow-sm p-6">
              <h2 className="text-lg font-semibold text-gray-900 mb-4">Registered Users</h2>
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">User</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Email</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Role</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-200">
                    <tr>
                      <td className="px-6 py-4">
                        <div className="flex items-center">
                          <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center mr-3">
                            <span className="text-blue-700 font-semibold">BA</span>
                          </div>
                          <span className="font-medium text-gray-900">Barangay Admin</span>
                        </div>
                      </td>
                      <td className="px-6 py-4 text-gray-600">admin@barangay.gov.ph</td>
                      <td className="px-6 py-4">
                        <span className="px-3 py-1 text-xs font-medium rounded-full bg-purple-100 text-purple-700">Admin</span>
                      </td>
                      <td className="px-6 py-4">
                        <span className="px-3 py-1 text-xs font-medium rounded-full bg-emerald-100 text-emerald-700">Active</span>
                      </td>
                    </tr>
                    <tr>
                      <td className="px-6 py-4">
                        <div className="flex items-center">
                          <div className="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center mr-3">
                            <span className="text-gray-700 font-semibold">JD</span>
                          </div>
                          <span className="font-medium text-gray-900">Juan Dela Cruz</span>
                        </div>
                      </td>
                      <td className="px-6 py-4 text-gray-600">user@example.com</td>
                      <td className="px-6 py-4">
                        <span className="px-3 py-1 text-xs font-medium rounded-full bg-blue-100 text-blue-700">User</span>
                      </td>
                      <td className="px-6 py-4">
                        <span className="px-3 py-1 text-xs font-medium rounded-full bg-emerald-100 text-emerald-700">Active</span>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* Settings Tab */}
          {activeTab === 'settings' && (
            <div className="space-y-6">
              <div className="bg-white rounded-xl shadow-sm p-6">
                <h2 className="text-lg font-semibold text-gray-900 mb-4">System Settings</h2>
                <div className="space-y-4 max-w-lg">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Barangay Name</label>
                    <input type="text" className="input-field" defaultValue="Barangay" />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Contact Email</label>
                    <input type="email" className="input-field" defaultValue="info@barangay.gov.ph" />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Contact Phone</label>
                    <input type="tel" className="input-field" defaultValue="(02) 8123-4567" />
                  </div>
                  <button className="btn-primary">Save Settings</button>
                </div>
              </div>
            </div>
          )}
        </div>
      </main>

      {/* Announcement Modal */}
      {showAnnouncementModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl max-w-lg w-full p-6">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-xl font-bold text-gray-900">
                {editingAnnouncement ? 'Edit Announcement' : 'Add Announcement'}
              </h3>
              <button onClick={() => setShowAnnouncementModal(false)} className="p-2 hover:bg-gray-100 rounded-lg">
                <X className="w-5 h-5" />
              </button>
            </div>
            <form className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Title</label>
                <input
                  type="text"
                  value={announcementForm.title}
                  onChange={(e) => setAnnouncementForm({ ...announcementForm, title: e.target.value })}
                  className="input-field"
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Category</label>
                <select
                  value={announcementForm.category}
                  onChange={(e) => setAnnouncementForm({ ...announcementForm, category: e.target.value as any })}
                  className="input-field"
                >
                  <option value="news">News</option>
                  <option value="event">Event</option>
                  <option value="advisory">Advisory</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Content</label>
                <textarea
                  value={announcementForm.content}
                  onChange={(e) => setAnnouncementForm({ ...announcementForm, content: e.target.value })}
                  className="input-field resize-none"
                  rows={4}
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Image URL (optional)</label>
                <input
                  type="url"
                  value={announcementForm.image}
                  onChange={(e) => setAnnouncementForm({ ...announcementForm, image: e.target.value })}
                  className="input-field"
                  placeholder="https://example.com/image.jpg"
                />
              </div>
              <div className="flex space-x-3">
                <button
                  type="button"
                  onClick={() => setShowAnnouncementModal(false)}
                  className="flex-1 py-3 border border-gray-300 rounded-lg font-medium hover:bg-gray-50"
                >
                  Cancel
                </button>
                <button
                  type="button"
                  onClick={handleSaveAnnouncement}
                  className="flex-1 btn-primary flex items-center justify-center space-x-2"
                >
                  <Save className="w-5 h-5" />
                  <span>Save</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
