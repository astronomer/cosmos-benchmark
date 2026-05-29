{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02100') }},
        {{ ref('model_01704') }}
)
select id, 'model_02895' as name from sources
