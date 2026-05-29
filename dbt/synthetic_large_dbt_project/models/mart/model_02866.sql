{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02102') }}
)
select id, 'model_02866' as name from sources
