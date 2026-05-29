{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00081') }},
        {{ ref('model_00215') }},
        {{ ref('model_00170') }}
)
select id, 'model_01054' as name from sources
