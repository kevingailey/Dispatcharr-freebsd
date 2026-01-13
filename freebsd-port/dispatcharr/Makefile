# FreeBSD Port: Dispatcharr
# IPTV Stream Management Platform
#
# To install from this port:
#   cd /usr/ports/multimedia/dispatcharr && make install clean
#
# Or using poudriere:
#   poudriere bulk -j 14amd64 -p default multimedia/dispatcharr

PORTNAME=	dispatcharr
DISTVERSION=	0.16.01
CATEGORIES=	multimedia www

MAINTAINER=	ports@FreeBSD.org
COMMENT=	Self-hosted IPTV stream management platform
WWW=		https://github.com/Dispatcharr/Dispatcharr

LICENSE=	MIT
LICENSE_FILE=	${WRKSRC}/LICENSE

# Fetch from GitHub
USE_GITHUB=	yes
GH_ACCOUNT=	Dispatcharr
GH_PROJECT=	Dispatcharr
GH_TAGNAME=	v${DISTVERSION}

# Build dependencies
BUILD_DEPENDS=	npm:www/npm \
		node:www/node

# Runtime dependencies
RUN_DEPENDS=	${PYTHON_PKGNAMEPREFIX}django50>=5.0:www/py-django50@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}psycopg2>=2.9:databases/py-psycopg2@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}celery>=5.3:devel/py-celery@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}redis>=4.0:databases/py-redis@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}djangorestframework>=3.14:www/py-djangorestframework@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}requests>=2.31:www/py-requests@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}psutil>=5.9:sysutils/py-psutil@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}pillow>=10.0:graphics/py-pillow@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}gevent>=23.0:devel/py-gevent@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}daphne>=4.0:www/py-daphne@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}gunicorn>=21.0:www/py-gunicorn@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}lxml>=4.9:devel/py-lxml@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}yaml>=6.0:devel/py-yaml@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}cryptography>=41.0:security/py-cryptography@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}pyjwt>=2.8:www/py-pyjwt@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}regex>=2023.0:textproc/py-regex@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}rapidfuzz>=3.0:devel/py-rapidfuzz@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}tzlocal>=5.0:devel/py-tzlocal@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}channels>=4.0:www/py-channels@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}channels-redis>=4.0:www/py-channels-redis@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}django-filter>=23.0:www/py-django-filter@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}django-cors-headers>=4.0:www/py-django-cors-headers@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}django-celery-beat>=2.5:www/py-django-celery-beat@${PY_FLAVOR} \
		ffmpeg:multimedia/ffmpeg \
		streamlink:multimedia/streamlink \
		redis-server:databases/redis \
		nginx:www/nginx

# PostgreSQL dependency
USES=		pgsql python shebangfix
USE_PYTHON=	autoplist concurrent
USE_RC_SUBR=	dispatcharr dispatcharr_celery dispatcharr_celerybeat dispatcharr_daphne
WANT_PGSQL=	server

# Shebang fixes
SHEBANG_FILES=	manage.py

# User/group for the service
USERS=		dispatcharr
GROUPS=		dispatcharr

# Installation directories
DISPATCHARR_DIR=	${PREFIX}/dispatcharr
DISPATCHARR_DATADIR=	/var/db/dispatcharr
DISPATCHARR_LOGDIR=	/var/log/dispatcharr
DISPATCHARR_RUNDIR=	/var/run/dispatcharr

# SUB_LIST for rc.d scripts and configuration
SUB_LIST=	DISPATCHARR_DIR=${DISPATCHARR_DIR} \
		DISPATCHARR_DATADIR=${DISPATCHARR_DATADIR} \
		DISPATCHARR_LOGDIR=${DISPATCHARR_LOGDIR} \
		DISPATCHARR_RUNDIR=${DISPATCHARR_RUNDIR} \
		DISPATCHARR_USER=${USERS} \
		DISPATCHARR_GROUP=${GROUPS} \
		PYTHON_CMD=${PYTHON_CMD}

SUB_FILES=	pkg-message dispatcharr.conf

# Options
OPTIONS_DEFINE=		PYTORCH DOCS
OPTIONS_DEFAULT=	PYTORCH
PYTORCH_DESC=		Enable PyTorch for AI-based EPG matching

PYTORCH_RUN_DEPENDS=	${PYTHON_PKGNAMEPREFIX}pytorch>=2.0:misc/py-pytorch@${PY_FLAVOR}

# No configure step needed
NO_CONFIGURE=	yes

.include <bsd.port.options.mk>

do-build:
	@${ECHO_MSG} "===> Building frontend assets"
	cd ${WRKSRC}/frontend && npm install --legacy-peer-deps
	cd ${WRKSRC}/frontend && npm run build

do-install:
	@${ECHO_MSG} "===> Installing Dispatcharr"
	# Create installation directories
	${MKDIR} ${STAGEDIR}${DISPATCHARR_DIR}
	${MKDIR} ${STAGEDIR}${DISPATCHARR_DATADIR}
	${MKDIR} ${STAGEDIR}${DISPATCHARR_DATADIR}/logos
	${MKDIR} ${STAGEDIR}${DISPATCHARR_DATADIR}/uploads
	${MKDIR} ${STAGEDIR}${DISPATCHARR_DATADIR}/backups
	${MKDIR} ${STAGEDIR}${DISPATCHARR_DATADIR}/plugins
	${MKDIR} ${STAGEDIR}${DISPATCHARR_LOGDIR}
	${MKDIR} ${STAGEDIR}${DISPATCHARR_RUNDIR}
	${MKDIR} ${STAGEDIR}${ETCDIR}

	# Copy application files
	cd ${WRKSRC} && ${COPYTREE_SHARE} . ${STAGEDIR}${DISPATCHARR_DIR} \
		"! -name .git ! -name .gitignore ! -name node_modules ! -name __pycache__"

	# Copy built frontend
	${MKDIR} ${STAGEDIR}${DISPATCHARR_DIR}/frontend/dist
	cd ${WRKSRC}/frontend/dist && ${COPYTREE_SHARE} . ${STAGEDIR}${DISPATCHARR_DIR}/frontend/dist

	# Install configuration file
	${INSTALL_DATA} ${WRKDIR}/dispatcharr.conf ${STAGEDIR}${ETCDIR}/dispatcharr.conf.sample

	# Install nginx configuration
	${MKDIR} ${STAGEDIR}${PREFIX}/etc/nginx
	${INSTALL_DATA} ${FILESDIR}/nginx-dispatcharr.conf.in \
		${STAGEDIR}${PREFIX}/etc/nginx/dispatcharr.conf.sample

	# Set ownership
	${CHOWN} -R ${USERS}:${GROUPS} ${STAGEDIR}${DISPATCHARR_DIR}
	${CHOWN} -R ${USERS}:${GROUPS} ${STAGEDIR}${DISPATCHARR_DATADIR}
	${CHOWN} -R ${USERS}:${GROUPS} ${STAGEDIR}${DISPATCHARR_LOGDIR}
	${CHOWN} -R ${USERS}:${GROUPS} ${STAGEDIR}${DISPATCHARR_RUNDIR}

	# Make manage.py executable
	${CHMOD} +x ${STAGEDIR}${DISPATCHARR_DIR}/manage.py

post-install:
	@${ECHO_MSG} "===> Creating symbolic links for data directories"
	${LN} -sf ${DISPATCHARR_DATADIR}/logos ${STAGEDIR}${DISPATCHARR_DIR}/logo_cache
	${LN} -sf ${DISPATCHARR_DATADIR}/uploads ${STAGEDIR}${DISPATCHARR_DIR}/uploads

.include <bsd.port.mk>
