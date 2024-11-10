export const ONGOING_CAMPAIGN_EMPTY_STATE_CONTENT = [
  {
    id: 1,
    title: 'Bem Vindos',
    inbox: {
      id: 2,
      name: 'PaperLayer Website',
      channel_type: 'Channel::WebWidget',
      phone_number: '',
    },
    sender: {
      id: 1,
      name: 'Brenda Melo',
    },
    message:
      'Olá! 👋 Precisa de ajuda com nossos produtos e serviços? Estamos aqui para responder qualquer dúvida!',
    campaign_status: 'active',
    enabled: true,
    campaign_type: 'ongoing',
    trigger_rules: {
      url: 'https://www.chatwoot.com/features/chatbot/',
      time_on_page: 10,
    },
    trigger_only_during_business_hours: true,
    created_at: '2024-10-24T13:10:26.636Z',
    updated_at: '2024-10-24T13:10:26.636Z',
  },
  {
    id: 2,
    title: 'Boas Vindas',
    inbox: {
      id: 2,
      name: 'PaperLayer Website',
      channel_type: 'Channel::WebWidget',
      phone_number: '',
    },
    sender: {
      id: 1,
      name: 'Victor Carvalho',
    },
    message:
      'Oi! 👋 Posso ajudar com algo relacionado às suas compras ou ao suporte? Sinta-se à vontade para perguntar!',
    campaign_status: 'active',
    enabled: false,
    campaign_type: 'ongoing',
    trigger_rules: {
      url: 'https://www.chatwoot.com/pricings',
      time_on_page: 10,
    },
    trigger_only_during_business_hours: false,
    created_at: '2024-10-24T13:11:08.763Z',
    updated_at: '2024-10-24T13:11:08.763Z',
  },
  {
    id: 3,
    title: 'Boas Vindas',
    inbox: {
      id: 2,
      name: 'PaperLayer Website',
      channel_type: 'Channel::WebWidget',
      phone_number: '',
    },
    sender: {
      id: 1,
      name: 'Rafaela Correia',
    },
    message:
      'Olá! 👋 Precisa de alguma assistência com nossas soluções? Estamos prontos para ajudar, é só perguntar!',
    campaign_status: 'active',
    enabled: false,
    campaign_type: 'ongoing',
    trigger_rules: {
      url: 'https://{*.}?chatwoot.com/apps/account/*/settings/inboxes/new/',
      time_on_page: 10,
    },
    trigger_only_during_business_hours: false,
    created_at: '2024-10-24T13:11:44.285Z',
    updated_at: '2024-10-24T13:11:44.285Z',
  },
  {
    id: 4,
    title: 'Boas Vindas',
    inbox: {
      id: 2,
      name: 'PaperLayer Website',
      channel_type: 'Channel::WebWidget',
      phone_number: '',
    },
    sender: {
      id: 1,
      name: 'Gustavo Rodrigues',
    },
    message:
      'Oi! 👋 Posso ajudar com algo relacionado às suas compras ou ao suporte? Sinta-se à vontade para perguntar!',
    campaign_status: 'active',
    enabled: true,
    campaign_type: 'ongoing',
    trigger_rules: {
      url: 'https://siv.com',
      time_on_page: 200,
    },
    trigger_only_during_business_hours: false,
    created_at: '2024-10-29T19:54:33.741Z',
    updated_at: '2024-10-29T19:56:26.296Z',
  },
];

export const ONE_OFF_CAMPAIGN_EMPTY_STATE_CONTENT = [
  {
    id: 1,
    title: 'Boas Vindas',
    inbox: {
      id: 6,
      name: 'PaperLayer Mobile',
      channel_type: 'Channel::Sms',
      phone_number: '+29818373149903',
      provider: 'default',
    },
    message:
      'Oi! 👋 Tem alguma dúvida ou precisa de mais informações sobre nossos serviços? Estamos à disposição para ajudar!',
    campaign_status: 'active',
    enabled: true,
    campaign_type: 'one_off',
    scheduled_at: 1729775588,
    audience: [
      { id: 4, type: 'Label' },
      { id: 5, type: 'Label' },
      { id: 6, type: 'Label' },
    ],
    trigger_rules: {},
    trigger_only_during_business_hours: false,
    created_at: '2024-10-24T13:13:08.496Z',
    updated_at: '2024-10-24T13:15:38.698Z',
  },
  {
    id: 2,
    title: 'Boas Vindas',
    inbox: {
      id: 6,
      name: 'PaperLayer Mobile',
      channel_type: 'Channel::Sms',
      phone_number: '+29818373149903',
      provider: 'default',
    },
    message:
      'Bem-vindo! 👋 Precisa de ajuda para planejar sua estadia ou tem perguntas sobre nossos serviços? Estamos aqui para tornar sua experiência incrível!',
    campaign_status: 'completed',
    enabled: true,
    campaign_type: 'one_off',
    scheduled_at: 1729732500,
    audience: [
      { id: 1, type: 'Label' },
      { id: 6, type: 'Label' },
      { id: 5, type: 'Label' },
      { id: 2, type: 'Label' },
      { id: 4, type: 'Label' },
    ],
    trigger_rules: {},
    trigger_only_during_business_hours: false,
    created_at: '2024-10-24T13:14:00.168Z',
    updated_at: '2024-10-24T13:15:38.707Z',
  },
  {
    id: 3,
    title: 'Boas Vindas',
    inbox: {
      id: 6,
      name: 'PaperLayer Mobile',
      channel_type: 'Channel::Sms',
      phone_number: '+29818373149903',
      provider: 'default',
    },
    message:
      'Oi! 👋 Tem dúvidas sobre nossos cursos ou precisa de informações adicionais? Estamos aqui para esclarecer tudo o que precisar!',
    campaign_status: 'completed',
    enabled: true,
    campaign_type: 'one_off',
    scheduled_at: 1730304840,
    audience: [
      { id: 1, type: 'Label' },
      { id: 3, type: 'Label' },
      { id: 6, type: 'Label' },
    ],
    trigger_rules: {},
    trigger_only_during_business_hours: false,
    created_at: '2024-10-29T16:14:10.374Z',
    updated_at: '2024-10-30T16:15:03.157Z',
  },
];
