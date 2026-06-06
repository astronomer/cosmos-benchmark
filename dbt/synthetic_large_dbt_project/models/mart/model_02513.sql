{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02158') }},
        {{ ref('model_01705') }},
        {{ ref('model_01789') }}
)
select id, 'model_02513' as name from sources
