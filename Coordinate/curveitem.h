#ifndef CURVEITEM_H
#define CURVEITEM_H

#include <QQuickPaintedItem>
#include <QPainter>
#include <QObject>

class CurveItem : public QQuickPaintedItem
{
    Q_OBJECT

//    Q_PROPERTY( QString style READ style WRITE setStyle )
    Q_PROPERTY( float itemWidth WRITE setItemWidth )
    Q_PROPERTY( float xAxisMax READ xAxisMax WRITE setxAxisMax )
    Q_PROPERTY( float xAxisMin READ xAxisMin WRITE setXAxisMin )
    Q_PROPERTY( float yAxisMax READ yAxisMax WRITE setYAxisMax )
    Q_PROPERTY( float yAxisMin READ yAxisMin WRITE setYAxisMin )
    Q_PROPERTY( float xAxisWidth READ xAxisWidth WRITE setXAxisWidth NOTIFY xAxisWidthChanged )
    Q_PROPERTY( float yAxisHeight READ yAxisHeight WRITE setYAxisHeight )

public:
    explicit CurveItem(QQuickItem *parent = 0);
    virtual ~CurveItem();
    void paint(QPainter *painter);

    float xAxisMax() { return mf_x_axis_max; }
    float xAxisMin() { return mf_x_axis_min; }
    float yAxisMax() { return mf_y_axis_max; }
    float yAxisMin() { return mf_y_axis_min; }
    float xAxisWidth() { return mf_x_axis_width; }
    float yAxisHeight() { return mf_y_axis_height; }

signals:
    void xAxisWidthChanged( float width );

public slots:
    void setItemWidth( float f_item_width ) { mf_item_width = f_item_width; }
    void setxAxisMax( float f_x_axis_max ) { mf_x_axis_max = f_x_axis_max; }
    void setXAxisMin( float f_x_axis_min ) { mf_x_axis_min = f_x_axis_min; }
    void setYAxisMax( float f_y_axis_max ) { mf_y_axis_max = f_y_axis_max; }
    void setYAxisMin( float f_y_axis_min ) { mf_y_axis_min = f_y_axis_min; }
    void setXAxisWidth( float f_x_axis_width ) { mf_x_axis_width = f_x_axis_width; emit xAxisWidthChanged( f_x_axis_width ); }
    void setYAxisHeight( float f_y_axis_height ) { mf_y_axis_height = f_y_axis_height; }

    void add_line_data( QList<QString> s_temper_list, QString s_color );
    void remove_line_data( int index ) { m_line_temper_assemble.removeAt( index ); }
    void clear_data() { m_line_temper_assemble.clear(); }
    void rePaint() { this->update(); }

    float xAxis_value_to_pos( float f_value );
    float yAxis_value_to_pos( float f_value );
    int xAxis_pos_to_point( float f_pos );

//private:
//    void calculate_xAxis_scale();
//    void calculate_yAxis_scale();

private:
    typedef struct _LineAna{
        QString lineColor;
        QList<QString> temperAssemble;
    } LineAna;

    float mf_item_width;
    float mf_x_axis_max;
    float mf_x_axis_min;
    float mf_y_axis_max;
    float mf_y_axis_min;
    float mf_x_axis_width;
    float mf_y_axis_height;

    QList<LineAna*> m_line_temper_assemble;
};

#endif // CURVEITEM_H
