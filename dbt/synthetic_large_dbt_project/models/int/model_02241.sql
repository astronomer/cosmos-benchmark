{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01471') }},
        {{ ref('model_01009') }},
        {{ ref('model_01030') }}
)
select id, 'model_02241' as name from sources
