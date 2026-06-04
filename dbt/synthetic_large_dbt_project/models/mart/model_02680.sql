{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01573') }},
        {{ ref('model_01568') }},
        {{ ref('model_01759') }}
)
select id, 'model_02680' as name from sources
