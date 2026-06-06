{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01351') }},
        {{ ref('model_01410') }},
        {{ ref('model_01142') }}
)
select id, 'model_02227' as name from sources
