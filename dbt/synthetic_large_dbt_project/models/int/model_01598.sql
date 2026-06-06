{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01328') }},
        {{ ref('model_00929') }},
        {{ ref('model_00816') }}
)
select id, 'model_01598' as name from sources
