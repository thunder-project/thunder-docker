FROM jupyter/minimal

MAINTAINER Andrew Osheroff <andrewosh@gmail.com>

USER root

RUN apt-get update

RUN export HOME=$(pwd)

# Java setup
RUN apt-get install -y default-jre
ENV JAVA_HOME $(readlink -f /usr/bin/java | sed "s:bin/java::") 

# Spark setup 
RUN wget http://mirror.reverse.net/pub/apache/spark/spark-1.3.1/spark-1.3.1-bin-hadoop2.6.tgz 
RUN tar -xzf spark-1.3.1-bin-hadoop2.6.tgz
ENV SPARK_HOME `pwd`/spark-1.3.1-bin-hadoop2.6
ENV PATH $PATH:$SPARK_HOME/bin

# Install useful Python packages
RUN apt-get install -y libxrender1 fonts-dejavu && apt-get clean
RUN conda create --yes -q -n python2.7-env python=2.7 nose numpy pandas scikit-learn scikit-image matplotlib scipy seaborn sympy cython patsy statsmodels cloudpickle numba bokeh pillow ipython
ENV PATH $CONDA_DIR/bin:$PATH
RUN conda install --yes numpy pandas scikit-learn scikit-image matplotlib scipy seaborn sympy cython patsy statsmodels cloudpickle numba bokeh pillow && conda clean -yt

# Thunder setup
RUN apt-get install -y git python-pip ipython gcc
RUN git clone https://github.com/thunder-project/thunder
RUN pip install -r thunder/python/requirements.txt
ENV THUNDER_ROOT $HOME/thunder
ENV PATH $PATH:$THUNDER_ROOT/python/bin
ENV PYTHONPATH $PYTHONPATH:$THUNDER_ROOT/python

RUN git clone https://github.com/CodeNeuro/neurofinder
ENV NEUROFINDER_ROOT $HOME/neurofinder

# Make Tutorial/Community/Neurofinder folders
RUN mkdir $HOME/notebooks
RUN mkdir $HOME/notebooks/community

# Do the symlinking
RUN mkdir $HOME/notebooks/neurofinder
RUN mkdir $HOME/notebooks/tutorials
RUN echo "In directory: " `pwd`
RUN ln -s $(readlink -f $THUNDER_ROOT/python/doc/tutorials/*.ipynb) $HOME/notebooks/tutorials/
RUN ln -s $(readlink -f $NEUROFINDER_ROOT/notebooks/*.ipynb) $HOME/notebooks/neurofinder/

# Set up the kernelspec
RUN /opt/conda/envs/python2.7-env/bin/ipython kernelspec install-self

WORKDIR $HOME/notebooks

CMD ipython notebook

