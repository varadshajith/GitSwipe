import 'dart:ui';

/// GitSwipe — Repository data model


class Repository {
  final String id;
  final String name;
  final String owner;
  final String description;
  final String language;
  final Color languageColor;
  final int stars;
  final int forks;
  final List<String> topics;
  final String? cardSummary;
  final String? deepDive;
  final String? license;
  final String githubUrl;
  final int? commitFrequency; // commits per week
  final double? starVelocity; // stars per day

  const Repository({
    required this.id,
    required this.name,
    required this.owner,
    required this.description,
    required this.language,
    required this.languageColor,
    required this.stars,
    required this.forks,
    required this.topics,
    this.cardSummary,
    this.deepDive,
    this.license,
    required this.githubUrl,
    this.commitFrequency,
    this.starVelocity,
  });
}

// ─── Mock Data ───────────────────────────────────────────────────────────────

final List<Repository> mockRepositories = [
  Repository(
    id: '1',
    name: 'turbo',
    owner: 'vercel',
    description:
        'The high-performance build system for JavaScript and TypeScript codebases. Fast, scalable, and beautifully architected.',
    language: 'TypeScript',
    languageColor: const Color(0xFF3178C6),
    stars: 26400,
    forks: 1820,
    topics: ['build-system', 'monorepo', 'typescript', 'performance'],
    cardSummary:
        'A blazing-fast monorepo build system by Vercel that uses intelligent caching and task scheduling to dramatically speed up CI/CD pipelines.',
    license: 'MIT',
    githubUrl: 'https://github.com/vercel/turbo',
    commitFrequency: 45,
    starVelocity: 12.3,
  ),
  Repository(
    id: '2',
    name: 'hyper-ui-core',
    owner: 'hyperui',
    description:
        'A headless design system engine designed for extreme performance and radical customizability.',
    language: 'Rust',
    languageColor: const Color(0xFFDEA584),
    stars: 8740,
    forks: 312,
    topics: ['design-system', 'headless', 'wasm', 'react'],
    cardSummary:
        'A sophisticated Atomic Design foundation built for high-performance React ecosystems with polymorphic components and design token bridging.',
    license: 'Apache-2.0',
    githubUrl: 'https://github.com/hyperui/hyper-ui-core',
    commitFrequency: 28,
    starVelocity: 5.7,
  ),
  Repository(
    id: '3',
    name: 'tailwind-motion',
    owner: 'romboHQ',
    description:
        'A high-performance animation engine specifically built for Tailwind CSS utility classes.',
    language: 'TypeScript',
    languageColor: const Color(0xFF3178C6),
    stars: 4320,
    forks: 189,
    topics: ['animation', 'tailwind', 'css', 'motion'],
    cardSummary:
        'Adds fluid, spring-based animations to Tailwind CSS with zero-config utility classes and GPU-accelerated transforms.',
    license: 'MIT',
    githubUrl: 'https://github.com/romboHQ/tailwind-motion',
    commitFrequency: 12,
    starVelocity: 8.1,
  ),
  Repository(
    id: '4',
    name: 'lucide-react',
    owner: 'lucide-icons',
    description:
        'Beautiful & consistent icons made by the community, optimized for React applications.',
    language: 'JavaScript',
    languageColor: const Color(0xFFF1E05A),
    stars: 12100,
    forks: 540,
    topics: ['icons', 'react', 'svg', 'design'],
    cardSummary:
        'A community-driven icon library with 1000+ pixel-perfect SVG icons, tree-shakeable and fully typed for React.',
    license: 'ISC',
    githubUrl: 'https://github.com/lucide-icons/lucide',
    commitFrequency: 18,
    starVelocity: 3.4,
  ),
  Repository(
    id: '5',
    name: 'rust-core-utils',
    owner: 'uutils',
    description:
        'Modern, memory-safe implementation of classic Unix utilities rewritten in Rust.',
    language: 'Rust',
    languageColor: const Color(0xFFDEA584),
    stars: 18500,
    forks: 1340,
    topics: ['rust', 'unix', 'cli', 'systems-programming'],
    cardSummary:
        'A cross-platform, memory-safe rewrite of GNU coreutils in Rust. Drop-in replacement for cat, ls, cp and 90+ more.',
    license: 'MIT',
    githubUrl: 'https://github.com/uutils/coreutils',
    commitFrequency: 32,
    starVelocity: 6.9,
  ),
  Repository(
    id: '6',
    name: 'ai-image-pipe',
    owner: 'ml-tools',
    description:
        'Standardized pipelines for local stable diffusion inference with zero-config setup.',
    language: 'Python',
    languageColor: const Color(0xFF3572A5),
    stars: 7200,
    forks: 420,
    topics: ['ai', 'stable-diffusion', 'pipeline', 'inference'],
    cardSummary:
        'Run Stable Diffusion locally with pre-built pipelines, automatic model downloading, and a unified API for text-to-image and img2img.',
    license: 'Apache-2.0',
    githubUrl: 'https://github.com/ml-tools/ai-image-pipe',
    commitFrequency: 22,
    starVelocity: 15.2,
  ),
];
