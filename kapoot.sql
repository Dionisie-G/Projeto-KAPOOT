-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Tempo de geração: 16-Abr-2026 às 10:03
-- Versão do servidor: 8.2.0
-- versão do PHP: 8.2.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `kapoot`
--

CREATE DATABASE IF NOT EXISTS `kapoot` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `kapoot`;

-- --------------------------------------------------------

--
-- Estrutura da tabela `avaliacoes`
--

DROP TABLE IF EXISTS `avaliacoes`;
CREATE TABLE IF NOT EXISTS `avaliacoes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `utilizador_id` int DEFAULT NULL,
  `kahoot_id` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `utilizador_id` (`utilizador_id`,`kahoot_id`),
  KEY `kahoot_id` (`kahoot_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `conquistas`
--

DROP TABLE IF EXISTS `conquistas`;
CREATE TABLE IF NOT EXISTS `conquistas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_general_ci,
  `pontos` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `jogadores_partida`
--

DROP TABLE IF EXISTS `jogadores_partida`;
CREATE TABLE IF NOT EXISTS `jogadores_partida` (
  `id` int NOT NULL AUTO_INCREMENT,
  `partida_id` int NOT NULL,
  `utilizador_id` int DEFAULT NULL,
  `nickname` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pontos` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `partida_id` (`partida_id`),
  KEY `utilizador_id` (`utilizador_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `kapoots`
--

DROP TABLE IF EXISTS `kapoots`;
CREATE TABLE IF NOT EXISTS `kapoots` (
  `id` int NOT NULL AUTO_INCREMENT,
  `utilizador_id` int NOT NULL,
  `titulo` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci,
  `visibilidade` enum('publico','privado') COLLATE utf8mb4_general_ci DEFAULT 'publico',
  `vezes_jogado` int DEFAULT '0',
  `avaliacao_media` decimal(3,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `utilizador_id` (`utilizador_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `niveis`
--

DROP TABLE IF EXISTS `niveis`;
CREATE TABLE IF NOT EXISTS `niveis` (
  `nivel` int NOT NULL,
  `xp_necessario` int NOT NULL,
  PRIMARY KEY (`nivel`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `niveis`
--

INSERT INTO `niveis` (`nivel`, `xp_necessario`) VALUES
(1, 0),
(2, 1000),
(3, 2500),
(4, 5000),
(5, 10000),
(6, 20000);

-- --------------------------------------------------------

--
-- Estrutura da tabela `partidas`
--

DROP TABLE IF EXISTS `partidas`;
CREATE TABLE IF NOT EXISTS `partidas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `kahoot_id` int NOT NULL,
  `criador_id` int NOT NULL,
  `codigo_sala` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `estado` enum('espera','em_jogo','finalizado') COLLATE utf8mb4_general_ci DEFAULT 'espera',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_sala` (`codigo_sala`),
  KEY `kahoot_id` (`kahoot_id`),
  KEY `criador_id` (`criador_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `perguntas`
--

DROP TABLE IF EXISTS `perguntas`;
CREATE TABLE IF NOT EXISTS `perguntas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `kahoot_id` int NOT NULL,
  `pergunta` text COLLATE utf8mb4_general_ci NOT NULL,
  `tempo_limite` int DEFAULT '20',
  `pontos` int DEFAULT '1000',
  PRIMARY KEY (`id`),
  KEY `kahoot_id` (`kahoot_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `respostas`
--

DROP TABLE IF EXISTS `respostas`;
CREATE TABLE IF NOT EXISTS `respostas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pergunta_id` int NOT NULL,
  `resposta` text COLLATE utf8mb4_general_ci NOT NULL,
  `correta` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `pergunta_id` (`pergunta_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `respostas_jogador`
--

DROP TABLE IF EXISTS `respostas_jogador`;
CREATE TABLE IF NOT EXISTS `respostas_jogador` (
  `id` int NOT NULL AUTO_INCREMENT,
  `jogador_id` int NOT NULL,
  `pergunta_id` int NOT NULL,
  `resposta_id` int NOT NULL,
  `correta` tinyint(1) DEFAULT NULL,
  `tempo_resposta` decimal(5,2) DEFAULT NULL,
  `pontos_ganhos` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `jogador_id` (`jogador_id`),
  KEY `pergunta_id` (`pergunta_id`),
  KEY `resposta_id` (`resposta_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `utilizadores`
--

DROP TABLE IF EXISTS `utilizadores`;
CREATE TABLE IF NOT EXISTS `utilizadores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `nivel` int DEFAULT '1',
  `experiencia` int DEFAULT '0',
  `total_pontos` int DEFAULT '0',
  `kapoots_criados` int DEFAULT '0',
  `kapoots_jogados` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `utilizador_conquistas`
--

DROP TABLE IF EXISTS `utilizador_conquistas`;
CREATE TABLE IF NOT EXISTS `utilizador_conquistas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `utilizador_id` int DEFAULT NULL,
  `conquista_id` int DEFAULT NULL,
  `data_obtida` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `utilizador_id` (`utilizador_id`),
  KEY `conquista_id` (`conquista_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
