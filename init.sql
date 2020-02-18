CREATE DATABASE IF NOT EXISTS `ae_data` /*!40100 DEFAULT CHARACTER SET latin1 */;
use `ae_data`;
CREATE TABLE IF NOT EXISTS `dinamica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dataHora` datetime DEFAULT NULL,
  `taxa` decimal(10,0) DEFAULT NULL,
  `oferta` int(11) DEFAULT NULL,
  `procura` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `senha` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pagamento_tipo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `empresa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) DEFAULT NULL,
  `cnpj` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_empresa_usuario_id_idx` (`usuario_id`),
  CONSTRAINT `FK_empresa_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `empresa_pagamento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pedido_id` int(11) DEFAULT NULL,
  `valor` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `empresa_pagamento_lancamento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pagamento_id` int(11) DEFAULT NULL,
  `pagamento_tipo_id` int(11) DEFAULT NULL,
  `valor_recebido` decimal(10,0) DEFAULT NULL,
  `observacao` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `estornado` tinyint(4) DEFAULT NULL,
  `bandeira` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `numero_autorizacao` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `data_recebimento` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_empresa_pagamento_lancamento_pagamento_id_idx` (`pagamento_id`),
  KEY `FK_empresa_pagamento_lancamento_pagamento_tipo_id_idx` (`pagamento_tipo_id`),
  CONSTRAINT `FK_empresa_pagamento_lancamento_pagamento_id` FOREIGN KEY (`pagamento_id`) REFERENCES `empresa_pagamento` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_empresa_pagamento_lancamento_pagamento_tipo_id` FOREIGN KEY (`pagamento_tipo_id`) REFERENCES `pagamento_tipo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `empresa_produto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `empresa_id` int(11) DEFAULT NULL,
  `sku` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `gtin` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `descricao` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `preco` decimal(10,0) DEFAULT NULL,
  `estoque` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_empresa_produto_empresa_id_idx` (`empresa_id`),
  CONSTRAINT `FK_empresa_produto_empresa_id` FOREIGN KEY (`empresa_id`) REFERENCES `empresa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `encomenda` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pedido_id` int(11) DEFAULT NULL,
  `descricao` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `tipo_encomenda` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `solicitacao_entrega` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) DEFAULT NULL,
  `encomenda_id` int(11) DEFAULT NULL,
  `coordenada_retirada` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `coordenada_entrega` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `data` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_solicitacao_entrega_usuario_id_idx` (`usuario_id`),
  KEY `FK_solicitacao_entrega_encomenda_id_idx` (`encomenda_id`),
  CONSTRAINT `FK_solicitacao_entrega_encomenda_id` FOREIGN KEY (`encomenda_id`) REFERENCES `encomenda` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_solicitacao_entrega_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `entregador` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) DEFAULT NULL,
  `ativo` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_entregador_usuario_id_idx` (`usuario_id`),
  CONSTRAINT `FK_entregador_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `entregador_documentacao` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entregador_id` int(11) DEFAULT NULL,
  `numero_cnh` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `categoria` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_entregador_documentacao_entregador_id_idx` (`entregador_id`),
  CONSTRAINT `FK_entregador_documentacao_entregador_id` FOREIGN KEY (`entregador_id`) REFERENCES `entregador` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `entregador_veiculo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entregador_id` int(11) DEFAULT NULL,
  `placa` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `chassi` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_entregador_veiculo_entregador_id_idx` (`entregador_id`),
  CONSTRAINT `FK_entregador_veiculo_entregador_id` FOREIGN KEY (`entregador_id`) REFERENCES `entregador` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `entrega` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `solicitacao_id` int(11) DEFAULT NULL,
  `entregador_id` int(11) DEFAULT NULL,
  `data_hora_inicio` datetime DEFAULT NULL,
  `data_hora_fim` datetime DEFAULT NULL,
  `concluida` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_entrega_solicitacao_id_idx` (`solicitacao_id`),
  KEY `FK_entrega_entregador_id_idx` (`entregador_id`),
  CONSTRAINT `FK_entrega_entregador_id` FOREIGN KEY (`entregador_id`) REFERENCES `entregador` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_entrega_solicitacao_id` FOREIGN KEY (`solicitacao_id`) REFERENCES `solicitacao_entrega` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `entregadores_online` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entregador_id` int(11) DEFAULT NULL,
  `geo_location` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pagamento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `solicitacao_id` int(11) DEFAULT NULL,
  `valor` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_pagamento_solicitacao_id_idx` (`solicitacao_id`),
  CONSTRAINT `FK_pagamento_solicitacao_id` FOREIGN KEY (`solicitacao_id`) REFERENCES `solicitacao_entrega` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pagamento_lancamento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pagamento_id` int(11) DEFAULT NULL,
  `pagamento_tipo_id` int(11) DEFAULT NULL,
  `numero_autorizacao` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `bandeira` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `estornado` tinyint(4) DEFAULT NULL,
  `observacao` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `valor_recebido` decimal(10,0) DEFAULT NULL,
  `data_recebimento` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_pagamento_lancamento_pagamento_id_idx` (`pagamento_id`),
  KEY `FK_pagamento_lancamento_pagamento_tipo_idx` (`pagamento_tipo_id`),
  CONSTRAINT `FK_pagamento_lancamento_pagamento_id` FOREIGN KEY (`pagamento_id`) REFERENCES `pagamento` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_pagamento_lancamento_pagamento_tipo` FOREIGN KEY (`pagamento_tipo_id`) REFERENCES `pagamento_tipo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pedido` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `empresa_id` int(11) DEFAULT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `data_hora` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_pedido_empresa_id_idx` (`empresa_id`),
  KEY `FK_pedido_usuario_id_idx` (`usuario_id`),
  CONSTRAINT `FK_pedido_empresa_id` FOREIGN KEY (`empresa_id`) REFERENCES `empresa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_pedido_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pedido_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pedido_id` int(11) DEFAULT NULL,
  `empresa_produto_id` int(11) DEFAULT NULL,
  `quantidade` float DEFAULT NULL,
  `preco` decimal(10,0) DEFAULT NULL,
  `atributos` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_pedido_item_pedido_id_idx` (`pedido_id`),
  KEY `FK_pedido_item_empresa_produto_id_idx` (`empresa_produto_id`),
  CONSTRAINT `FK_pedido_item_empresa_produto_id` FOREIGN KEY (`empresa_produto_id`) REFERENCES `empresa_produto` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_pedido_item_pedido_id` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pedido_pagamento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pedido_id` int(11) DEFAULT NULL,
  `valor_pagamento` decimal(10,0) DEFAULT NULL,
  `data_hora` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_pedido_pagamento_pedido_id_idx` (`pedido_id`),
  CONSTRAINT `FK_pedido_pagamento_pedido_id` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pedido_pagamento_lancamento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pedido_pagamento_id` int(11) DEFAULT NULL,
  `valor_pago` decimal(10,0) DEFAULT NULL,
  `data_hora` datetime DEFAULT NULL,
  `observacao` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `numero_autorizacao` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `bandeira` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `estornado` tinyint(4) DEFAULT NULL,
  `pagamento_tipo_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_pedido_pagamento_lancamento_pedido_pagamento_id_idx` (`pedido_pagamento_id`),
  KEY `FK_pedido_pagamento_lancamento_pagamento_tipo_id_idx` (`pagamento_tipo_id`),
  CONSTRAINT `FK_pedido_pagamento_lancamento_pagamento_tipo_id` FOREIGN KEY (`pagamento_tipo_id`) REFERENCES `pagamento_tipo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_pedido_pagamento_lancamento_pedido_pagamento_id` FOREIGN KEY (`pedido_pagamento_id`) REFERENCES `pedido_pagamento` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `rota` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordem` int(11) DEFAULT NULL,
  `entregador_id` int(11) DEFAULT NULL,
  `geo_location` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `dependencia_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
