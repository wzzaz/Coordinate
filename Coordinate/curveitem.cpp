#include "curveitem.h"
#include <iostream>
#include <time.h>
#include "stdlib.h"
#include <QPen>
#include <QDebug>

CurveItem::CurveItem(QQuickItem *parent):
    QQuickPaintedItem(parent)
{
    mf_x_axis_min = 0;
    mf_x_axis_max = 100;
    mf_y_axis_min = 0;
    mf_y_axis_max = 100;
    LineAna *initAna = new LineAna;
    double x;
    srand((unsigned)time(NULL)); //srand(3)
    for( int i = 0; i < 100; ++i ) {
        x = rand();
        initAna->temperAssemble.append( QString::number( x / 1000 + 30, 'f', 0 ) );
    }
    initAna->lineColor = "black";
    m_line_temper_assemble.append( initAna );
    qDebug() << "temperAssemble" << initAna->temperAssemble;
}

CurveItem::~CurveItem()
{
}

void CurveItem::paint(QPainter *painter)
{
    if( m_line_temper_assemble.size() <= 0 ) {
        qDebug() << "Empty";
        return;
    }

    QPen pen;
    pen.setWidth( 1 );
    QFont font = painter->font();
    font.setPixelSize( 12 );
    painter->setFont( font );

    {
        for( int i = 0; i < m_line_temper_assemble.size(); i++ ) {
            QList<QString> s_one_line_data = m_line_temper_assemble.at(i)->temperAssemble;
            if( s_one_line_data.length() < 1 ) {
                qDebug() << "CurveItem::paint()  s_one_line_data.length() < 1";
                break;
            }
            pen.setColor( QColor( m_line_temper_assemble.at(i)->lineColor ) );
            painter->setPen( pen );
            QPainterPath line_path;
            for( int j = 0; j < s_one_line_data.length(); j++ ) {
                float f_point = s_one_line_data.at(j).toFloat();
                QPointF point( xAxis_value_to_pos( j ), yAxis_value_to_pos( f_point ) );
                if( j == 0 ) {
                    line_path.moveTo( point );
                } else {
                    line_path.lineTo( point );
                }
            }
            painter->drawPath( line_path );
        }
    }
}

float CurveItem::xAxis_value_to_pos(float f_value)
{
    float f_pos;
    float f_min_axis, f_range_axis;
    f_min_axis = mf_x_axis_min;
    f_range_axis = mf_x_axis_max - mf_x_axis_min;
    f_pos = ( f_value - f_min_axis ) * ( mf_item_width / f_range_axis );
    return f_pos;
}

float CurveItem::yAxis_value_to_pos(float f_value)
{
    float f_pos;
    f_pos = ( mf_y_axis_max - f_value ) * ( mf_y_axis_height / ( mf_y_axis_max - mf_y_axis_min ) );
    return f_pos;
}

int CurveItem::xAxis_pos_to_point(float f_pos)
{
    float f_range_axis = mf_x_axis_max - mf_x_axis_min;
    int n_point = f_pos / ( mf_item_width / f_range_axis ) + mf_x_axis_min;
    return n_point;
}

void CurveItem::add_line_data(QList<QString> s_temper_list, QString s_color)
{
    LineAna *new_ana = new LineAna;
    new_ana->lineColor = s_color;
    new_ana->temperAssemble = s_temper_list;
    m_line_temper_assemble.append( new_ana );
}
