{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01961') }},
        {{ ref('model_02052') }}
)
select id, 'model_02670' as name from sources
