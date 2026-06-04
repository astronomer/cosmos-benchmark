{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01062') }},
        {{ ref('model_00837') }}
)
select id, 'model_02052' as name from sources
