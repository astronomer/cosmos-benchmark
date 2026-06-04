{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00502') }},
        {{ ref('model_00157') }},
        {{ ref('model_00055') }}
)
select id, 'model_00825' as name from sources
