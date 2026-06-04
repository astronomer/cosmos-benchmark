{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01928') }},
        {{ ref('model_01920') }},
        {{ ref('model_01693') }}
)
select id, 'model_02322' as name from sources
