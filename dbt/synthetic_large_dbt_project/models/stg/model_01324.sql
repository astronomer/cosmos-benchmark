{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00209') }},
        {{ ref('model_00141') }},
        {{ ref('model_00342') }}
)
select id, 'model_01324' as name from sources
