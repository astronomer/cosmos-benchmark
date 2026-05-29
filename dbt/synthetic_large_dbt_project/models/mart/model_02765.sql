{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01794') }}
)
select id, 'model_02765' as name from sources
